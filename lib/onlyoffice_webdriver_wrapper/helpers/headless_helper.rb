# encoding: utf-8
require_relative 'logger_helper'
require_relative 'headless_helper/real_display_tools'
require_relative 'headless_helper/ruby_helper'
require 'headless'

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

  def start
    create_session = false
    if real_display_connected?
      if real_display_resolution_low? || !debug?
        create_session = true
      end
    else
      create_session = true
    end
    return unless create_session
    LoggerHelper.print_to_log('Starting Headless Session')
    begin
      @headless_instance = Headless.new(reuse: false,
                                        destroy_at_exit: true,
                                        dimensions: "#{@resolution_x + 1}x#{@resolution_y + 1}x24")
    rescue Exception => e
      LoggerHelper.print_to_log("xvfb not started with problem #{e}")
      RspecHelper.clean_up(true)
      @headless_instance = Headless.new(reuse: false,
                                        destroy_at_exit: true,
                                        dimensions: "#{@resolution_x + 1}x#{@resolution_y + 1}x24")
    end
    headless_instance.start
  end

  def stop
    return unless running?
    LoggerHelper.print_to_log('Stopping Headless Session')
    headless_instance.destroy
  end

  def running?
    !headless_instance.nil?
  end

  def take_screenshot(scr_path = '/tmp/screenshot.png')
    return unless running?
    headless_instance.take_screenshot(scr_path)
    LoggerHelper.print_to_log("Took Screenshot to file: #{scr_path}")
  end
end
