FactoryBot.define do
  factory :trip do
    name { "Test Trip #{rand(1000)}" }
    image_url { "https://example.com/image.jpg" }
    short_description { "Short description" }
    long_description { "Long description for the trip." }
    rating { rand(1..5) }
  end
end
