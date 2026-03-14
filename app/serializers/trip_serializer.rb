class TripSerializer

  include JSONAPI::Serializer

  set_type :trip

  cache_options store: Rails.cache, namespace: 'jsonapi-serializer', expires_in: 1.hour

  attributes :name, :image_url, :short_description, :long_description, :rating
end
