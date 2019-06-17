# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Module for check ruby info
  module RubyHelper
    def debug?
      ENV['RUBYLIB'].to_s.include?('ruby-debug')
    end

    # Check if current os is 64 bit
    # @return [True, False] result of comparision
    def os_64_bit?
      RUBY_PLATFORM.include?('_64')
    end
  end
end
