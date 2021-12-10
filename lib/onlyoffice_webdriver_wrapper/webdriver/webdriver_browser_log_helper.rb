# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods for working with browser console logs
  module WebdriverBrowserLogHelper
    # @return [Array] list of browser logs
    def browser_logs
      return [] if browser == :firefox # not implemented, see https://github.com/mozilla/geckodriver/issues/284

      @driver.manage.logs.get(:browser)
    end
  end
end
