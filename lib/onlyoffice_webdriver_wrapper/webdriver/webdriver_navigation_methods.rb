# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods for webdriver navigations
  module WebdriverNavigationMethods
    # Open specific url
    # @param [String] url to open
    # @return [nil]
    def open(url)
      url = "http://#{url}" unless url.include?('http') || url.include?('file://')
      ensure_url_available(url)
      @driver.navigate.to url
      sleep(1) # Correct wait for Page to init focus
      OnlyofficeLoggerHelper.log("Opened page: #{url}")
    rescue StandardError => e
      message = "Received error `#{e}` while opening page `#{url}`"
      OnlyofficeLoggerHelper.log(message)
      raise e.class, message, e.backtrace
    end

    # @return [String] url of current frame, or browser url if
    #   it is a root frame
    def get_url
      execute_javascript('return window.location.href')
    rescue Selenium::WebDriver::Error::NoSuchFrameError, Timeout::Error => e
      raise(e.class, "Browser is crushed or hangup with #{e}")
    end

    # Refresh current page
    # @return [nil]
    def refresh
      @driver.navigate.refresh
      OnlyofficeLoggerHelper.log('Refresh page')
    end

    # Go back like pressing `Back` button in browser
    # @return [nil]
    def go_back
      @driver.navigate.back
      OnlyofficeLoggerHelper.log('Go back to previous page')
    end

    # Quit current browser session
    # @return [nil]
    def quit
      return unless browser_running

      begin
        @driver.execute_script('window.onbeforeunload = null') # off popup window
      rescue StandardError
        Exception
      end
      begin
        @driver.quit
      rescue Exception => e
        OnlyofficeLoggerHelper.log("Some error happened on webdriver.quit #{e.backtrace}")
      end
      alert_confirm
      @headless.stop
      cleanup_download_folder
      @browser_running = false
    end

    private

    # Fast check if url available
    # @param [String] url to check
    # @param [Integer] timeout for wait for page to load
    # @raise [Net::ReadTimeout] exception if timeout happened
    # @return [nil]
    def ensure_url_available(url, timeout: 5)
      return true unless url.start_with?('http://')

      URI.parse(url).open(read_timeout: timeout,
                          open_timeout: timeout).read
    rescue StandardError => e
      OnlyofficeLoggerHelper.log("Url: #{url} is not available with error `#{e}`")
      raise Net::ReadTimeout, e
    end
  end
end
