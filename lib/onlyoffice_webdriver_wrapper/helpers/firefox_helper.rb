# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Module for working with firefox
  module FirefoxHelper
    def firefox_service
      geckodriver = File.join(File.dirname(__FILE__), 'bin/geckodriver')
      @firefox_service ||= Selenium::WebDriver::Firefox::Service.new(path: geckodriver)
    end

    # @return [Webdriver::Firefox] firefox webdriver
    def start_firefox_driver
      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.folderList'] = 2
      profile['browser.helperApps.neverAsk.saveToDisk'] = read_firefox_files_to_save
      profile['browser.download.dir'] = @download_directory
      profile['browser.download.manager.showWhenStarting'] = false
      profile['dom.disable_window_move_resize'] = false
      options = Selenium::WebDriver::Firefox::Options.new(profile: profile)
      caps = Selenium::WebDriver::Remote::Capabilities.firefox
      caps[:proxy] = Selenium::WebDriver::Proxy.new(ssl: "#{@proxy.proxy_address}:#{@proxy.proxy_port}") if @proxy
      if ip_of_remote_server.nil?
        driver = Selenium::WebDriver.for :firefox, options: options, service: firefox_service, desired_capabilities: caps
        driver.manage.window.size = Selenium::WebDriver::Dimension.new(headless.resolution_x, headless.resolution_y) if headless.running?
        driver
      else
        capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(firefox_profile: profile, desired_capabilities: caps)
        Selenium::WebDriver.for :remote, desired_capabilities: capabilities, url: 'http://' + ip_of_remote_server + ':4444/wd/hub'
      end
    end

    private

    # @return [Array<String>] list of formats to save
    def read_firefox_files_to_save
      path_to_file = "#{Dir.pwd}/lib/onlyoffice_webdriver_wrapper/"\
                     'helpers/firefox_helper/save_to_disk_files.list'
      OnlyofficeFileHelper::FileHelper.read_array_from_file(path_to_file)
                                      .join(', ')
    end
  end
end
