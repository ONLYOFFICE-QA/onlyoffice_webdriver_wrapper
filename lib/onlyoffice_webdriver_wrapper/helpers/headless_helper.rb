# frozen_string_literal: true

require_relative 'headless_helper/real_display_tools'
require_relative 'headless_helper/ruby_helper'
require 'headless'

module OnlyofficeWebdriverWrapper
  # Class for using headless gem
  class HeadlessHelper
    include RealDisplayTools
    include RubyHelper
    attr_accessor :headless_instance
    attr_accessor :resolution_x
    attr_accessor :resolution_y

    def initialize(resolution_x = 1680, resolution_y = 1050)
      @resolution_x = resolution_x
      @resolution_y = resolution_y
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
                                          dimensions: "#{@resolution_x + 1}x#{@resolution_y + 1}x24")
      rescue Exception => e
        OnlyofficeLoggerHelper.log("xvfb not started with problem #{e}")
        WebDriver.clean_up(true)
        @headless_instance = Headless.new(reuse: false,
                                          destroy_at_exit: true,
                                          dimensions: "#{@resolution_x + 1}x#{@resolution_y + 1}x24")
      end
      headless_instance.start
    end

    def stop
      return unless running?

      OnlyofficeLoggerHelper.log('Stopping Headless Session')
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
