FROM ruby:2.7.2

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

RUN bundle config set deployment 'true'

# We don't store any secrets on the hermes application
ENV RAILS_ENV=production SECRET_KEY_BASE="dummy"

WORKDIR /hermes

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install

COPY . .

ENTRYPOINT ["./docker/entrypoint.sh"]

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "--log-to-stdout"]