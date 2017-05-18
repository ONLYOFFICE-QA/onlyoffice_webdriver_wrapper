module OnlyofficeWebdriverWrapper
  # Methods for working with browser console logs
  module WebdriverBrowserLogHelper
    def browser_logs
      @driver.manage.logs.get(:browser)
    end
  end
end
