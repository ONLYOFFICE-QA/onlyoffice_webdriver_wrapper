# Module for wokring with webdriver useragent
module WebdriverUserAgentHelper
  USERAGENT_ANDROID_PHONE = 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MDB08M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.81 Mobile Safari/537.36'.freeze
  USERAGENT_IPHONE = 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_2 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13F69 Safari/601.1'.freeze

  # @return [String] user agent string for current device
  def user_agent_for_device
    case @device
    when :desktop_linux
      nil
    when :android_phone
      USERAGENT_ANDROID_PHONE
    when :iphone
      USERAGENT_IPHONE
    else
      webdriver_error("Unknown user device for starting browser: #{@device}")
    end
  end

  # @param [Array, String] current switches of browser
  # @return [String] user agent switch for browser
  def add_useragent_to_switches(switches)
    user_agent = user_agent_for_device
    return switches.dup if user_agent.nil?
    switches.dup << "--user-agent=#{user_agent}"
  end

  # @return [String] current user agent
  def current_user_agent
    execute_javascript('return navigator.userAgent;')
  end
end
