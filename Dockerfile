FROM ruby:2.6.3

WORKDIR /app

RUN curl -sL https://deb.nodesource.com/setup_13.x -o nodesource_setup.sh  && \
    bash nodesource_setup.sh && \
    apt install nodejs

# Copy Ruby and Node dependencies
COPY . .

# Install dependencies
RUN gem install bundler -v 2.3.19
RUN bundle install --without debug && npm install

RUN bundle exec middleman build --clean