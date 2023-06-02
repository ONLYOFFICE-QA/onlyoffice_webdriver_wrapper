# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

if ENV['CI']
  require 'simplecov-cobertura'
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end
require 'onlyoffice_webdriver_wrapper'

RSpec.configure do |config|
  config.before do
    puts 'Logging memory usage:'
    puts `cat /proc/meminfo`
  end
end

# Get full path for open in browser of local file
# @param file_name [String] name of file to load
# @return [String] path to local file
def local_file(file_name)
  "file://#{Dir.pwd}/spec/html_examples/" \
    "#{file_name}"
end

# Class for describing current page page object
class CurrentPagePageObject
  include PageObject

  element(:div, xpath: '//div')
  elements(:spans, xpath: '//span')
  elements(:car_elements, xpath: '//select/option')
  select(:car_select, xpath: '//select')

  def initialize(webdriver)
    super(webdriver.driver)
  end
end
