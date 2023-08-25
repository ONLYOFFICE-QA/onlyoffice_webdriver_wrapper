# frozen_string_literal: true

require 'net/protocol'

module OnlyofficeWebdriverWrapper
  # Methods for working with alerts
  module WebdriverAlertHelper
    # Exception which happens if there is no alerts
    NO_ALERT_EXCEPTIONS = [Errno::ECONNREFUSED,
                           Net::ReadTimeout,
                           Selenium::WebDriver::Error::InvalidSessionIdError,
                           Selenium::WebDriver::Error::NoSuchAlertError].freeze

    # Confirm current alert
    # @return [void]
    def alert_confirm
      @driver.switch_to.alert.accept if alert_exists?
    end

    # Check if alert exists
    # @return [Boolean]
    def alert_exists?
      @driver.switch_to.alert.text
      true
    rescue *NO_ALERT_EXCEPTIONS
      false
    end

    # Get alert text
    # @return [String] text inside alert
    def alert_text
      @driver.switch_to.alert.text
    end
  end
end
