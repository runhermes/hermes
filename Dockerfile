FROM ruby:2.7.1

RUN gem install bundler

RUN bundle config set deployment 'true'

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . ./

EXPOSE 4567

ENV CLIENT_ID=client_id CLIENT_SECRET=client_secret REDIRECT_URI=redirect_uri

CMD ["bundle", "exec", "rackup", "-p", "4567", "--host", "0.0.0.0"]