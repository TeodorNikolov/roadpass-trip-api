require 'json'

file = File.read(Rails.root.join('db/data.json'))
data = JSON.parse(file)

data["trips"].each do |trip|
  Trip.create!(
    name: trip["name"],
    image_url: trip["image"],
    short_description: trip["description"],
    long_description: trip["long_description"],
    rating: trip["rating"]
  )
end
