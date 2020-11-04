# Webhook Secrets

Hermes uses Webhook secrets to validate that the webhooks it receives from your Git host are legitimate.

## Generating a Webhook secret

If the `HERMES_WEBHOOK_SECRET` is not set, then Hermes will generate a webhook secret on startup. You will need to copy this secret and use to [configure your webhooks](./configure-webhooks.md).