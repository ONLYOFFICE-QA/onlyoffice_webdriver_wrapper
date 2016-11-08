module OnlyofficeWebdriverWrapper
  # Working with screenshots
  module WebdriverScreenshotHelper
    def get_screenshot_and_upload(path_to_screenshot = "/mnt/data_share/screenshot/WebdriverError/#{StringHelper.generate_random_string}.png")
      begin
        get_screenshot(path_to_screenshot)
        path_to_screenshot = AmazonS3Wrapper.new.upload_file_and_make_public(path_to_screenshot, 'screenshots')
        LoggerHelper.print_to_log("upload screenshot: #{path_to_screenshot}")
      rescue Errno::ENOENT => e
        begin
          @driver.save_screenshot(path_to_screenshot)
          LoggerHelper.print_to_log("Cant upload screenshot #{path_to_screenshot}. Error: #{e}")
        rescue Errno::ENOENT => e
          @driver.save_screenshot("tmp/#{File.basename(path_to_screenshot)}")
          LoggerHelper.print_to_log("Upload screenshot to tmp/#{File.basename(path_to_screenshot)}. Error: #{e}")
        end
      end
      path_to_screenshot
    end

    def get_screenshot(path_to_screenshot = "/mnt/data_share/screenshot/WebdriverError/#{StringHelper.generate_random_string}.png")
      FileHelper.create_folder(File.dirname(path_to_screenshot))
      @driver.save_screenshot(path_to_screenshot)
      LoggerHelper.print_to_log("get_screenshot(#{path_to_screenshot})")
    end

    def webdriver_screenshot(screenshot_name = SecureRandom.uuid)
      begin
        link = get_screenshot_and_upload("/mnt/data_share/screenshot/WebdriverError/#{screenshot_name}.png")
      rescue Exception
        if @headless.headless_instance.nil?
          system_screenshot("/tmp/#{screenshot_name}.png")
          begin
            link = AmazonS3Wrapper.new.upload_file_and_make_public("/tmp/#{screenshot_name}.png", 'screenshots')
          rescue Exception => e
            LoggerHelper.print_to_log("Error in get screenshot: #{e}. System screenshot #{link}")
          end
        else
          @headless.take_screenshot("/tmp/#{screenshot_name}.png")
          begin
            link = AmazonS3Wrapper.new.upload_file_and_make_public("/tmp/#{screenshot_name}.png", 'screenshots')
          rescue Exception => e
            LoggerHelper.print_to_log("Error in get screenshot: #{e}. Headless screenshot #{link}")
          end
        end
      end
      "screenshot: #{link}"
    end
  end
end
