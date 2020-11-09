# frozen_string_literal: true

class SettingsManager

  def self.update_tokens(tokens, logger)
    logger.info "Update tokens in settings"
    logger.info "Refresh token: #{token.refresh_token}"
    logger.info "Access token: #{token.access_token}"

    Settings.basecamp.refresh_token = token.refresh_token
    Settings.basecamp.access_token = token.access_token
  end
end