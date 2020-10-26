FROM ruby:2.7.2

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

ENV RAILS_ENV=production

RUN bundle config set deployment 'true'

WORKDIR /hermes

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY . .

ENTRYPOINT ["./docker/entrypoint.sh"]

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]