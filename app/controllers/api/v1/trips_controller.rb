module Api
  module V1
    class TripsController < ApplicationController
      before_action :set_trip, only: [:show]

      def index
        trips = Trip.all

        trips = trips.search(params[:search])
        trips = trips.min_rating(params[:min_rating])
        trips = trips.sorted(params[:sort])

        trips = trips.page(params[:page]).per(params[:per_page] || 10)

        render json: {
        data: trips.map { |trip| TripListSerializer.new(trip) },
        meta: pagination_meta(trips)
        }
      end

      def show
        render json: TripSerializer.new(@trip)
      end

      def create
        trip = Trip.new(trip_params)
        if trip.save
          render json: TripSerializer.new(trip), status: :created
        else
          render json: { errors: trip.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_trip
        @trip = Trip.find_by(id: params[:id])
        render json: { error: 'Trip not found' }, status: :not_found unless @trip
      end

      def trip_params
        params.require(:trip).permit(:name, :image_url, :short_description, :long_description, :rating)
      end

      def pagination_meta(paginated)
        {
          current_page: paginated.current_page,
          total_pages: paginated.total_pages,
          total_count: paginated.total_count
        }
      end
    end
  end
end
