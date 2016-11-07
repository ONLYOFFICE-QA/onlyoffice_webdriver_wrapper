module OnlyofficeWebdriverWrapper
  # Class for working with Chrome
  module ChromeHelper
    DEFAULT_CHROME_SWITCHES = %w(--kiosk-printing --start-maximized --disable-popup-blocking test-type).freeze

    # @return [Webdriver::Chrome] Chrome webdriver
    def start_chrome_driver
      Selenium::WebDriver::Chrome.driver_path = File.join(File.dirname(__FILE__), 'bin/chromedriver')
      prefs = {
        download: {
          prompt_for_download: false,
          default_directory: download_directory
        },
        profile: {
          default_content_settings: {
            'multiple-automatic-downloads' => 1
          }
        }
      }
      if ip_of_remote_server.nil?
        switches = add_useragent_to_switches(DEFAULT_CHROME_SWITCHES)
        begin
          driver = Selenium::WebDriver.for :chrome, prefs: prefs, switches: switches
          if headless.running?
            driver.manage.window.size = Selenium::WebDriver::Dimension.new(headless.resolution_x, headless.resolution_y)
          end
          driver
        rescue Selenium::WebDriver::Error::WebDriverError, Net::ReadTimeout # Problems with Chromedriver - hang ups
          kill_all
          sleep 5
          driver = Selenium::WebDriver.for :chrome, prefs: prefs, switches: switches
          driver.manage.window.size = Selenium::WebDriver::Dimension.new(headless.resolution_x, headless.resolution_y) if headless.running?
          driver
        end
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
