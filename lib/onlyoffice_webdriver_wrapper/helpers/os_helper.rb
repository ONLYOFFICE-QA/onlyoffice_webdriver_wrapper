# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Stuff for working with OS families
  class OSHelper
    # @return [True, False] Check if current platform is mac
    def self.mac?
      RUBY_PLATFORM.include?('darwin')
    end
  end
end
