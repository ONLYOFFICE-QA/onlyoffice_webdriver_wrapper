# encoding: utf-8
require_relative 'logger_helper'
require_relative 'linux_helper'
require 'headless'

# Class for using headless gem
class HeadlessHelper
  attr_accessor :headless_instance
  attr_accessor :resolution_x
  attr_accessor :resolution_y

  def initialize(resolution_x = 1681, resolution_y = 1050)
    @headless_instance = nil
    @resolution_x = resolution_x
    @resolution_y = resolution_y
  end

  def start
    create_session = false
    if LinuxHelper.real_display_connected?
      if LinuxHelper.real_display_resolution_low? || !RspecHelper.debug?
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
                                        dimensions: "#{@resolution_x}x#{@resolution_y}x24")
    rescue Exception => e
      LoggerHelper.print_to_log("xvfb not started with problem #{e}")
      RspecHelper.clean_up(true)
      @headless_instance = Headless.new(reuse: false,
                                        destroy_at_exit: true,
                                        dimensions: "#{@resolution_x}x#{@resolution_y}x24")
    end
    @headless_instance.start
  end

  def stop
    return if @headless_instance.nil?
    LoggerHelper.print_to_log('Stopping Headless Session')
    @headless_instance.destroy
  end

  def running?
    !@headless_instance.nil?
  end

  def take_screenshot(scr_path = '/tmp/screenshot.png')
    return if @headless_instance.nil?
    @headless_instance.take_screenshot(scr_path)
    LoggerHelper.print_to_log("Took Screenshot to file: #{scr_path}")
  end
end
