FROM ruby:2.7.2

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

WORKDIR /hermes

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install