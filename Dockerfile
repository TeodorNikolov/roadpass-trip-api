# Use official Ruby image
FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && \
    apt-get install -y nodejs postgresql-client yarn netcat && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile first to leverage caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler -v 2.4.10
RUN bundle install

# Copy the rest of the app
COPY . .

# Default command
CMD ["bash"]