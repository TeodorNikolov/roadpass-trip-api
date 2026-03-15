# Dockerfile
FROM ruby:3.2

# Install system dependencies
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       curl \
       gnupg2 \
       lsb-release \
       netcat \
       ca-certificates \
       apt-transport-https \
       dirmngr \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y yarn postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Gemfiles first to leverage caching
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.10
RUN bundle install

# Copy app code
COPY . .

CMD ["bash"]