# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods for working with alerts
  module WebdriverAlertHelper
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
    rescue Selenium::WebDriver::Error::NoSuchAlertError, Errno::ECONNREFUSED
      false
    end

    # Get alert text
    # @return [String] text inside alert
    def alert_text
      @driver.switch_to.alert.text
    end
  end
end
