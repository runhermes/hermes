# Hermes ![CI](https://github.com/runhermes/hermes/workflows/CI/badge.svg)

## What is Hermes?

A self-hosted Ruby application that listens for pull request events via webhooks to automate their interactions with Basecamp. It is deployed as a standalone application into your infrastructure. No third-party has access to your credentials.

Hermes listens for GitLab webhooks. It then reads the pull request description to determine if it contains Basecamp links that points to resources that can be managed with Hermes (e.g. To-dos).

### Linking pull request with Basecamp To-dos

You can link a pull request to an issue by using a supported keyword plus the Basecamp To-do URL in the pull request's description:

Keywords:

* close
* closes
* closed
* fix
* fixes
* fixed
* resolve
* resolves
* resolved


### How does it work?

Hermes implements the following workflows:

* A new PR is opened containing a link to a Basecamp To-do in the description:
  * Add a comment in the Basecamp To-do containing a link back to the PR and stating the following:
    * To-do is open, then it will be completed by the PR
    * To-do is completed/archived, then it just specifies that is being linked from the PR
* A PR is updated with a link to a Basecamp To-do in the description:
  * Checks if the PR has been linked already by a comment in the Basecamp To-do, otherwise it follows the same procedure as when opening a new PR
* Once PR is merged then:
  * To-do is open, add a comment stating that the PR has been merged and complete the To-do
  * To-do is closed, add a comment stating that the PR has been merged
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

Check out the [LICENSE](LICENSE) for details
