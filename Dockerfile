FROM ruby:3.2-bullseye

# Install system dependencies
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        curl \
        gnupg2 \
        lsb-release \
        netcat \
        postgresql-client \
        build-essential \
        libpq-dev \
        ca-certificates \
        apt-transport-https \
        dirmngr \
    && rm -rf /var/lib/apt/lists/*

# Install Node 20
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y yarn \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.10
RUN bundle install

# Copy the app code
COPY . .

CMD ["bash"]