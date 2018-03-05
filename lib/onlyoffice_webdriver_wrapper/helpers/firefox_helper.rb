module OnlyofficeWebdriverWrapper
  # Module for working with firefox
  module FirefoxHelper
    # @return [Webdriver::Firefox] firefox webdriver
    def start_firefox_driver
      geckodriver = File.join(File.dirname(__FILE__), 'bin/geckodriver')
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.folderList'] = 2
      profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/doct, application/mspowerpoint, application/msword, application/octet-stream, application/oleobject, application/pdf, application/powerpoint, application/pptt, application/rtf, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/vnd.oasis.opendocument.spreadsheet, application/vnd.oasis.opendocument.text, application/vnd.openxmlformats-officedocument.presentationml.presentation, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/x-compressed, application/x-excel, application/xlst, application/x-msexcel, application/x-mspowerpoint, application/x-rtf, application/x-zip-compressed, application/zip, image/jpeg, image/pjpeg, image/pjpeg, image/x-jps, message/rfc822, multipart/x-zip, text/csv, text/html, text/html, text/plain, text/richtext'
      profile['browser.download.dir'] = @download_directory
      profile['browser.download.manager.showWhenStarting'] = false
      profile['dom.disable_window_move_resize'] = false
      options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
      if ip_of_remote_server.nil?
        driver = Selenium::WebDriver.for :firefox, options: options, driver_path: geckodriver
        driver.manage.window.size = Selenium::WebDriver::Dimension.new(headless.resolution_x, headless.resolution_y) if headless.running?
        driver
      else
        capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(firefox_profile: profile)
        Selenium::WebDriver.for :remote, desired_capabilities: capabilities, url: 'http://' + ip_of_remote_server + ':4444/wd/hub'
      end
    end
  end
end
