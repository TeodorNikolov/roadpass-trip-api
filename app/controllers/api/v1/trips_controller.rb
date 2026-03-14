module Api
  module V1
    class TripsController < ApplicationController

      def index
        trips = Trip.search(params[:search])
                    .min_rating(params[:min_rating])
                    .sorted(params[:sort])
                    .page(params[:page])
                    .per(params[:per_page] || 10)

        render json: {
          data: trips.map { |trip| TripListSerializer.new(trip) },
          meta: pagination_meta(trips)
        }
      end

      def show
        trip = Trip.find(params[:id])
        render json: TripSerializer.new(trip)
      end

      def create
        trip = Trip.create!(trip_params)
        render json: TripSerializer.new(trip), status: :created
      end

      private

      def trip_params
        params.require(:trip).permit(
          :name,
          :image_url,
          :short_description,
          :long_description,
          :rating
        )
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
