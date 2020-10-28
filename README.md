# Hermes ![CI](https://github.com/runhermes/hermes/workflows/CI/badge.svg)

## Resources

* How to get started: [www.runhermes.io/guide](www.runhermes.io/guide) Not yet available
* Full documentation: [www.runhermes.io/docs](www.runhermes.io/docs) Not yet available
* Download the latest release: github.com/runatlantis/atlantis/releases/latest
* Start Contributing: [./CONTRIBUTING.md]

## What is Hermes?

A self-hosted ruby application that listens for pull request events via webhooks to automate their interactions with Basecamp.

## What does it do?

Hermes implements the following workflows:

* A new PR is opened containing a link to a Basecamp To-do in the description:
  * Add a comment in the Basecamp To-do containing a link back to the PR and stating the following:
    * To-do is open, then it will be completed by the PR
    * To-do is completed/archived, then it just specifies that is being linked from the PR
* A PR is updated with a link to a Basecamp To-do in the description:
  * Checks if the PR has been linked already by a comment in the Basecamp To-do, otherwise it follows the same procedure as when opening a new PR
* Once PR is merged then:
  * To-do is open, add a comment stating that the PR has been merged and complete the To-do
  * To-do is close, add a comment stating that the PR has been merged
* If PR is closed, then add a comment stating that the PR has been closed
* If PR is reopened, then add a comment stating that the PR is reopened

## Why should you use it?

* No longer need to manually close To-dos once the corresponding pull requests are merged
* Leave a trail of pull request actions in the To-do through comments

## Contributing

Check out the [Contributing](CONTRIBUTING.md) page.

## Changelog

For inspecting the changes and tag releases, check the [Changelog](CHANGELOG.md) page

## License

Checkout the [LICENSE](LICENSE) for details
