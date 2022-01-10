FROM ruby:2.6.3

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_13.x -o nodesource_setup.sh  && \
    bash nodesource_setup.sh && \
    apt install nodejs

# Copy Ruby and Node dependencies
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install --without debug && npm install

COPY . .

RUN bundle exec middleman build --clean