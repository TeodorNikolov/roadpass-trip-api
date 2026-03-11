class TripDetailSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :image_url, :short_description, :long_description, :rating
end
