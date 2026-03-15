module Api
  module V1
    class TripsController < ActionController::API
      # GET /api/v1/trips
      def index
        trips = Trip.search(params[:search])
                    .min_rating(params[:min_rating])
                    .sorted(params[:sort])
                    .page(params[:page])
                    .per(params[:per_page] || 10)

        render json: {
          data: trips.map { |trip| Api::V1::TripListSerializer.new(trip).as_json },
          meta: pagination_meta(trips)
        }, status: :ok
      end

      # GET /api/v1/trips/:id
      def show
        trip = Trip.find(params[:id])
        render json: Api::V1::TripSerializer.new(trip).serializable_hash, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ["Trip not found"] }, status: :not_found
      end

      # POST /api/v1/trips
      def create
        trip = Trip.new(trip_params)
        if trip.save
          render json: Api::V1::TripSerializer.new(trip).serializable_hash, status: :created
        else
          render json: { errors: trip.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

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
