module OnlyofficeWebdriverWrapper
  # Class for working with Chrome
  module ChromeHelper
    DEFAULT_CHROME_SWITCHES = %w(--kiosk-printing --start-maximized --disable-popup-blocking test-type).freeze

    # @return [String] path to chromedriver
    def chromedriver_path
      driver_name = 'bin/chromedriver'
      driver_name = 'bin/chromedriver_mac' if OSHelper.mac?
      File.join(File.dirname(__FILE__), driver_name)
    end

    # @return [Webdriver::Chrome] Chrome webdriver
    def start_chrome_driver
      prefs = {
        download: {
          prompt_for_download: false,
          default_directory: download_directory
        },
        profile: {
          default_content_settings: {
            'multiple-automatic-downloads' => 1
          }
        },
        credentials_enable_service: false
      }
      if ip_of_remote_server.nil?
        switches = add_useragent_to_switches(DEFAULT_CHROME_SWITCHES)
        webdriver_options = { prefs: prefs,
                              switches: switches,
                              driver_path: chromedriver_path }
        begin
          driver = Selenium::WebDriver.for :chrome, webdriver_options
        rescue Selenium::WebDriver::Error::WebDriverError,
               Net::ReadTimeout,
               Errno::ECONNREFUSED => e
          OnlyofficeLoggerHelper.log("Starting chrome failed with error: #{e.backtrace}")
          sleep 10
          driver = Selenium::WebDriver.for :chrome, webdriver_options
        end
        driver.manage.window.size = Selenium::WebDriver::Dimension.new(headless.resolution_x, headless.resolution_y) if headless.running?
        driver
      else
        caps = Selenium::WebDriver::Remote::Capabilities.chrome
        caps['chromeOptions'] = {
          profile: data['zip'],
          extensions: data['extensions']
        }
        Selenium::WebDriver.for(:remote, url: 'http://' + remote_server + ':4444/wd/hub', desired_capabilities: caps)
      end
    end
  end
end
