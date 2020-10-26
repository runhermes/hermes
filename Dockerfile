FROM runhermes/hermes-base

ENV RAILS_ENV=production

WORKDIR /hermes

COPY . .

ENTRYPOINT ["./docker/entrypoint.sh"]

# Start the main process.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]