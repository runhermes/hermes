# Deployment

## Architecture Overview

### Runtime

Hermes is a simple Rails API. It receives webhooks from your Git host and updates Basecamp resources accordingly.

### Routing

Your Git host needs to be able to route and communicate with Hermes  to send webhooks to Hermes. If you're using a public Git host like github.com, gitlab.com, then you'll need to expose Hermes to the internet.

If you're using a private Git host like GitHub Enterprise or GitLab Enterprise, then Hermes needs to be routable from the private host.

### Data

Hermes has no external database. Hermes routes all communications between the Git host and Basecamp during the request.

## Deployment Options

### Kubernetes Helm Chart

Hermes has an [official Helm Chart](https://github.com/runhermes/charts)

### Docker

Hermes has an official [Docker image](https://hub.docker.com/r/runhermes/hermes/): `runhermes/hermes`
