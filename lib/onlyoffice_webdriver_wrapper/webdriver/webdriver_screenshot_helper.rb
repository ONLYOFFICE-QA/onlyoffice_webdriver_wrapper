require 'onlyoffice_s3_wrapper'
module OnlyofficeWebdriverWrapper
  # Working with screenshots
  module WebdriverScreenshotHelper
    # @return [String] location of screenshot to take
    def screenshot_folder
      '/tmp/screenshot/WebdriverError'
    end

    def get_screenshot_and_upload(path_to_screenshot = "#{screenshot_folder}/#{StringHelper.generate_random_string}.png")
      begin
        get_screenshot(path_to_screenshot)
        cloud_screenshot = OnlyofficeS3Wrapper::AmazonS3Wrapper.new.upload_file_and_make_public(path_to_screenshot, 'screenshots')
        File.delete(path_to_screenshot) if File.exist?(path_to_screenshot)
        OnlyofficeLoggerHelper.log("upload screenshot: #{cloud_screenshot}")
        return cloud_screenshot
      rescue Errno::ENOENT => e
        begin
          @driver.save_screenshot(path_to_screenshot)
          OnlyofficeLoggerHelper.log("Cant upload screenshot #{path_to_screenshot}. Error: #{e}")
        rescue Errno::ENOENT => e
          @driver.save_screenshot("tmp/#{File.basename(path_to_screenshot)}")
          OnlyofficeLoggerHelper.log("Upload screenshot to tmp/#{File.basename(path_to_screenshot)}. Error: #{e}")
        end
      end
      path_to_screenshot
    end

    def get_screenshot(path_to_screenshot = "#{screenshot_folder}/#{StringHelper.generate_random_string}.png")
      screenshot_folder = File.dirname(path_to_screenshot)
      FileUtils.mkdir_p(screenshot_folder) unless File.directory?(screenshot_folder)
      @driver.save_screenshot(path_to_screenshot)
      OnlyofficeLoggerHelper.log("get_screenshot(#{path_to_screenshot})")
    end

    def webdriver_screenshot(screenshot_name = SecureRandom.uuid)
      begin
        link = get_screenshot_and_upload("#{screenshot_folder}/#{screenshot_name}.png")
      rescue Exception => e
        OnlyofficeLoggerHelper.log("Error in get screenshot: #{e}. Trying to get headless screenshot")
        if @headless.headless_instance.nil?
          system_screenshot("/tmp/#{screenshot_name}.png")
          begin
            link = OnlyofficeS3Wrapper::AmazonS3Wrapper.new.upload_file_and_make_public("/tmp/#{screenshot_name}.png", 'screenshots')
          rescue Exception => e
            OnlyofficeLoggerHelper.log("Error in get screenshot: #{e}. System screenshot #{link}")
          end
        else
          @headless.take_screenshot("/tmp/#{screenshot_name}.png")
          begin
            link = OnlyofficeS3Wrapper::AmazonS3Wrapper.new.upload_file_and_make_public("/tmp/#{screenshot_name}.png", 'screenshots')
          rescue Exception => e
            OnlyofficeLoggerHelper.log("Error in get screenshot: #{e}. Headless screenshot #{link}")
          end
        end
      end
      "screenshot: #{link}"
    end
  end
end
