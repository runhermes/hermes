FROM ruby:2.7.1

RUN gem install bundler

RUN bundle config set deployment 'true'

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . ./

EXPOSE 4567

CMD ["bundle", "exec", "rackup", "-p", "4567", "--host", "0.0.0.0"]