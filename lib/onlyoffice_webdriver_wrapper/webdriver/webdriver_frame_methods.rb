# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods for webdriver frame operations
  module WebdriverFrameMethods
    # Select frame as current
    # @param [String] xpath_name name of current xpath
    # @param [Integer] count_of_frames how much times select xpath_name
    # @return [nil]
    def select_frame(xpath_name = '//iframe', count_of_frames = 1)
      (0...count_of_frames).each do
        frame = @driver.find_element(:xpath, xpath_name)
        @driver.switch_to.frame frame
      rescue Selenium::WebDriver::Error::NoSuchElementError
        OnlyofficeLoggerHelper.log('Raise NoSuchElementError in the select_frame method')
      rescue Exception => e
        webdriver_error("Raise unknown exception: #{e}")
      end
    end

    # Select top frame of browser (even if several sub-frames exists)
    # @return [nil]
    def select_top_frame
      @driver.switch_to.default_content
    rescue Timeout::Error
      OnlyofficeLoggerHelper.log('Raise TimeoutError in the select_top_frame method')
    rescue Exception => e
      raise "Browser is crushed or hangup with error: #{e}"
    end
  end
end
