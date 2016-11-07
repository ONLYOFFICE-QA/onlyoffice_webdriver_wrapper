module OnlyofficeWebdriverWrapper
  # Some additional methods for webdriver
  module WebdriverHelper
    def kill_all
      LoggerHelper.print_to_log('killall -9 chromedriver 2>&1')
      `killall -9 chromedriver 2>&1`
    end

    def system_screenshot(file_name)
      `import -window root #{file_name}`
    end
  end
end
