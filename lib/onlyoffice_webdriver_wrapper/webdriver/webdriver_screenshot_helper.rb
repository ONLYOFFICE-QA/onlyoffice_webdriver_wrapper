# frozen_string_literal: true

require 'fileutils'
require 'onlyoffice_s3_wrapper'
module OnlyofficeWebdriverWrapper
  # Working with screenshots
  module WebdriverScreenshotHelper
    # @return [String] content type of png image
    SCREENSHOT_CONTENT_TYPE = 'image/png'

    # @return [OnlyofficeS3Wrapper::AmazonS3Wrapper] s3 wrapper
    def amazon_s3_wrapper
      @amazon_s3_wrapper ||= OnlyofficeS3Wrapper::AmazonS3Wrapper.new(bucket_name: 'webdriver-wrapper-screenshots',
                                                                      region: 'us-east-1')
    end

    # @return [String] location of screenshot to take
    def screenshot_folder
      '/tmp/screenshot/WebdriverError'
    end

    # Get screenshot of current windows and upload it to cloud storage
    # @param [String] path_to_screenshot place to store local screenshot
    # @return [String] url of public screenshot
    def get_screenshot_and_upload(path_to_screenshot = "#{screenshot_folder}/#{StringHelper.generate_random_string}.png")
      begin
        get_screenshot(path_to_screenshot)
        cloud_screenshot = publish_screenshot(path_to_screenshot)
        FileUtils.rm_rf(path_to_screenshot)
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

    # Get screenshot of current window
    # @param [String] path_to_screenshot place to store local screenshot
    # @return [void]
    def get_screenshot(path_to_screenshot = "#{screenshot_folder}/#{StringHelper.generate_random_string}.png")
      screenshot_folder = File.dirname(path_to_screenshot)
      FileUtils.mkdir_p(screenshot_folder) unless File.directory?(screenshot_folder)
      @driver.save_screenshot(path_to_screenshot)
      OnlyofficeLoggerHelper.log("get_screenshot(#{path_to_screenshot})")
    end

    # Make a screenshot by webdriver methods
    # @param [String] screenshot_name random name for file
    # @return [String] text string with screenshot file location
    def webdriver_screenshot(screenshot_name = SecureRandom.uuid)
      begin
        link = get_screenshot_and_upload("#{screenshot_folder}/#{screenshot_name}.png")
      rescue Exception => e
        OnlyofficeLoggerHelper.log("Error in get screenshot: #{e}. Trying to get headless screenshot")
        if @headless.headless_instance.nil?
          system_screenshot("/tmp/#{screenshot_name}.png")
          begin
            link = publish_screenshot("/tmp/#{screenshot_name}.png")
          rescue Exception => e
            OnlyofficeLoggerHelper.log("Error in get screenshot: #{e}. System screenshot #{link}")
          end
        else
          @headless.take_screenshot("/tmp/#{screenshot_name}.png")
          begin
            link = publish_screenshot("/tmp/#{screenshot_name}.png")
          rescue Exception => e
            OnlyofficeLoggerHelper.log("Error in get screenshot: #{e}. Headless screenshot #{link}")
          end
        end
      end
      "screenshot: #{link}"
    end

    private

    # Publish screenshot
    # @param [String] path to file
    # @return [String] public internet link to file
    def publish_screenshot(path)
      amazon_s3_wrapper.upload_file_and_make_public(path,
                                                    nil,
                                                    SCREENSHOT_CONTENT_TYPE)
    end
  end
end
