module Trips
  class CreateTrip

    def initialize(params)
      @params = params
    end

    def call
      Trip.create(@params)
    end
  end
end
