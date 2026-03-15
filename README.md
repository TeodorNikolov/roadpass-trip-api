Roadpass API

This is the Roadpass API built with Rails 8 and PostgreSQL, containerized using Docker Compose. This README includes setup, commands, and testing instructions for a fully local development environment.

Prerequisites

Docker

Docker Compose

Note: No need to install Ruby, Rails, or PostgreSQL locally. Everything runs inside Docker.

Local Setup

Clone the repository

git clone https://github.com/TeodorNikolov/roadpass_api.git
cd roadpass_api


Create .env file (optional, if you need environment variables)

RAILS_ENV=development
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=roadpass_dev


Build and start Docker Compose

docker-compose up --build


This will build the Rails app image, start the Rails server, and PostgreSQL database.

Rails API will be accessible at http://localhost:3000

Database Setup

Run the following commands inside the Docker container:

# Enter the Rails container
docker-compose exec app bash

# Create and migrate the database
rails db:create db:migrate db:seed


rails db:create → creates dev/test databases

rails db:migrate → runs migrations

rails db:seed → seeds sample data (optional)

Running the API

Inside the container:

rails s -b 0.0.0.0


Access API endpoints at http://localhost:3000/api/v1/...

Example endpoints:

Method	Path	Description
GET	/api/v1/trips	List all trips
GET	/api/v1/trips/:id	Show a single trip
POST	/api/v1/trips	Create a new trip
Running Tests

Run all RSpec tests inside Docker:

docker-compose exec app bundle exec rspec


You should see 0 failures if the setup is correct.

To run a single spec file:

docker-compose exec app bundle exec rspec spec/requests/api/v1/trips_spec.rb

Useful Commands
Command	Description
docker-compose up	Start app and database containers
docker-compose up --build	Rebuild containers and start
docker-compose exec app bash	Open a shell inside Rails container
rails db:create db:migrate db:seed	Setup database inside container
rails c	Rails console inside container
bundle exec rspec	Run all tests inside container
docker-compose down	Stop and remove containers
Notes

Windows host: Do not try to run Rails or PostgreSQL natively. Use Docker Compose to avoid hostname issues like db not found.

Serializer changes: API responses are consistent with TripSerializer for single trips and TripListSerializer for lists.
