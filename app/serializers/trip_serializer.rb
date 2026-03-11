class TripSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :image_url, :short_description, :rating
end
