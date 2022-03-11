# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Module for working with webdriver useragent
  module WebdriverUserAgentHelper
    # @return [String] useragent for Android phone browser
    USERAGENT_ANDROID_PHONE = 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MDB08M) '\
                              'AppleWebKit/537.36 (KHTML, like Gecko) '\
                              'Chrome/51.0.2704.81 Mobile Safari/537.36'
    # @return [String] useragent for iPhone browser
    USERAGENT_IPHONE = 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3_2 like Mac OS X) '\
                       'AppleWebKit/601.1.46 (KHTML, like Gecko) '\
                       'Version/9.0 Mobile/13F69 Safari/601.1'
    # @return [String] useragent for iPad Air 2 Safari browser
    USERAGENT_IPAD_AIR_2_SAFARI = 'Mozilla/5.0 (iPad; CPU OS 10_0 like Mac OS X) '\
                                  'AppleWebKit/602.1.50 (KHTML, like Gecko) '\
                                  'Version/10.0 Mobile/14A5346a Safari/602.1'
    # @return [String] useragent for Nexus 10 Chrome browser
    USERAGENT_NEXUS_10_CHROME = 'Mozilla/5.0 (Linux; Android 4.3; Nexus 10 Build/JSS15Q) '\
                                'AppleWebKit/537.36 (KHTML, like Gecko) '\
                                'Chrome/48.0.2564.23 Safari/537.36'

    # @return [String, nil] user agent string for current device
    def user_agent_for_device
      case @device
      when :desktop_linux
        nil
      when :android_phone
        USERAGENT_ANDROID_PHONE
      when :iphone
        USERAGENT_IPHONE
      when :ipad_air_2_safari
        USERAGENT_IPAD_AIR_2_SAFARI
      when :nexus_10_chrome
        USERAGENT_NEXUS_10_CHROME
      else
        raise("Unknown user device for starting browser: #{@device}")
      end
    end

    # @param switches [Array, String] current switches of browser
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
end
