FactoryBot.define do
  factory :trip do
    sequence(:name) { |n| "Trip #{n}" }
    image_url { "https://example.com/image.jpg" }
    short_description { "Short description" }
    long_description { "Long description of the trip." }
    rating { 4 }
  end
end
