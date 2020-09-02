# frozen_string_literal: true

require_relative 'headless_helper/real_display_tools'
require_relative 'headless_helper/ruby_helper'
require 'headless'
require_relative 'headless_helper/headless_screenshot_patch'
require_relative 'headless_helper/headless_video_recorder'

module OnlyofficeWebdriverWrapper
  # Class for using headless gem
  class HeadlessHelper
    include HeadlessVideoRecorder
    include RealDisplayTools
    include RubyHelper
    # @return [Headless] instance of headless object
    attr_accessor :headless_instance
    # @return [Integer] x resolution of virtual screen
    attr_accessor :resolution_x
    # @return [Integer] y resolution of virtual screen
    attr_accessor :resolution_y
    # @return [True, False] is video should be recorded
    attr_reader :record_video

    def initialize(resolution_x = 1680,
                   resolution_y = 1050,
                   record_video: true)
      @resolution_x = resolution_x
      @resolution_y = resolution_y
      @record_video = record_video
    end

    # Check if should start headless
    # @return [True, False] result
    def should_start?
      return false if debug?
      return false if OSHelper.mac?

      true
    end

    def start
      create_session = if real_display_connected?
                         should_start?
                       else
                         true
                       end
      return unless create_session

      OnlyofficeLoggerHelper.log('Starting Headless Session')
      begin
        @headless_instance = Headless.new(reuse: false,
                                          destroy_at_exit: true,
                                          dimensions: "#{@resolution_x + 1}x#{@resolution_y + 1}x24",
                                          video: { provider: :ffmpeg })
      rescue Exception => e
        OnlyofficeLoggerHelper.log("xvfb not started with problem #{e}")
        WebDriver.clean_up(true)
        @headless_instance = Headless.new(reuse: false,
                                          destroy_at_exit: true,
                                          dimensions: "#{@resolution_x + 1}x#{@resolution_y + 1}x24",
                                          video: { provider: :ffmpeg })
      end
      headless_instance.start
      start_capture
    end

    def stop
      return unless running?

      OnlyofficeLoggerHelper.log('Stopping Headless Session')
      stop_capture
      headless_instance.destroy
    end

    def running?
      !headless_instance.nil?
    end

    def take_screenshot(scr_path = '/tmp/screenshot.png')
      return unless running?

      headless_instance.take_screenshot(scr_path)
      OnlyofficeLoggerHelper.log("Took Screenshot to file: #{scr_path}")
    end
  end
end
