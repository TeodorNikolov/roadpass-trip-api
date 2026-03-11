class Api::V1::TripsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    trips = Trip.all
    trips = trips.search(params[:search])
    trips = trips.min_rating(params[:min_rating])
    trips = sort_trips(trips)
    trips = trips.page(params[:page]).per(params[:per_page] || 10)

    render json: {
      data: TripSerializer.new(trips),
      meta: {
        page: trips.current_page,
        total_pages: trips.total_pages,
        total_count: trips.total_count
      }
    }
  end

  def show
    trip = Trip.find(params[:id])
    render json: TripDetailSerializer.new(trip)
  end

  def create
    trip = Trip.new(trip_params)

    if trip.save
      render json: TripDetailSerializer.new(trip), status: :created
    else
      render json: { errors: trip.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def trip_params
    params.require(:trip).permit(
      :name, :image_url, :short_description, :long_description, :rating
    )
  end

  def sort_trips(trips)
    case params[:sort]
    when "rating_desc"
      trips.order(rating: :desc)
    when "rating_asc"
      trips.order(rating: :asc)
    else
      trips.order(:name)
    end
  end

  def record_not_found
    render json: { error: "Trip not found" }, status: :not_found
  end
end
