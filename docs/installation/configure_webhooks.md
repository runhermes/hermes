# Configure Webhooks

Hermes needs to receive webhooks from your git host to be able to respond to pull requests

See instructions for your specific provider below

## GitLab

If you're using GitLab, navigate to your project's home page in GitLab

* Click **Settings > Webooks** in the sidebar
* Set **URL** to `http://$URL/gitlab/webhook` (or `https://$URL/gitlab/webhook` if you're using SSL) where `$URL` is the Hermes location.
* Set Secret Token to the Webhook Secret you generated previously
  * *NOTE* If you're adding a webhook to multiple repositories, each repository will need to use the same secret.
* Check the boxes
  * Merge Request events
* Leave Enable SSL verification checked
* Click Add webhook