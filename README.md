This project is a Ruby on Rails API serving trip/destination data. It supports listing, filtering, sorting, pagination, and retrieving details for individual trips.

The API is backed by PostgreSQL and includes RSpec tests, factory_bot for test data, and a background job example using Sidekiq.

Table of Contents

Tech Stack

Setup

Database

Running the App

API Endpoints

Testing

Background Jobs

Design Decisions

Future Improvements

Tech Stack

Ruby 3.2 / Rails 8.1

PostgreSQL 15+

Sidekiq + Redis

RSpec, FactoryBot, Shoulda Matchers, Fakeredis (for tests)

Docker + Docker Compose (for easy local setup)

Setup
Requirements

Docker
 and Docker Compose

Optional: Local Ruby and Postgres (if not using Docker)

Steps
# Clone repo
git clone <repo_url>
cd <repo_folder>

# Build and start containers
docker-compose up --build

# Enter Rails container
docker-compose exec web bash

# Install gems (if needed)
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

The API will be available at http://localhost:3000.

Database

Trip Model Fields:

Field	Type	Notes
name	string	Required
image_url	string	Required
short_description	string	Required
long_description	text	Required
rating	integer	1–5, required

Validations: All fields required, rating between 1–5. Indexes on name and rating for faster search/filter.

Seed Data: Loaded from data.json (20 trips).

API Endpoints
Method	Path	Description	Query Params
GET	/api/v1/trips	List trips (supports search/filter/sort/pagination)	search, min_rating, sort, page, per_page
GET	/api/v1/trips/:id	Retrieve full trip details	-
POST	/api/v1/trips	Create a new trip	JSON body: name, image_url, short_description, long_description, rating

Testing

All tests are written in RSpec with FactoryBot and Shoulda Matchers.

Run all tests:
docker-compose exec web bundle exec rspec
Run a specific job test:
docker-compose exec web bundle exec rspec spec/jobs/nightly_trip_summary_job_spec.rb
Run request specs:
docker-compose exec web bundle exec rspec spec/requests/api/v1/trips_spec.rb
Background Jobs

Example background job: NightlyTripSummaryJob

Summarizes trips by rating nightly

Logs summary to Rails logger

Uses Sidekiq queue default

Run Sidekiq:

docker-compose exec sidekiq bundle exec sidekiq
Design Decisions

API Versioning: /api/v1 path prefix for future-proofing

Serializer/Presenter: Avoid exposing database fields directly; only return required attributes

Strong Parameters: Ensure only allowed fields are created/updated

Fakeredis: Used in tests to avoid connecting to real Redis

Pagination: Default 10 per page; supports page/per_page query params

Future Improvements

Add caching for trips index to reduce DB load

Add CI/CD workflow (GitHub Actions) to run tests on each push

Add authentication for secure trip creation

Enhance background job with email notifications