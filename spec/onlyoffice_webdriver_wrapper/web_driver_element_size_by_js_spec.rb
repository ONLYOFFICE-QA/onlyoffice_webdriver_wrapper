# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#element_size_by_js' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'web_driver_element_size_by_js_spec.html')
  end

  after { webdriver.quit }

  it 'element_size_by_js for full screen element' do
    dimensions = webdriver.element_size_by_js('//div')
    expect(dimensions.height).to be > (webdriver.browser_size.y / 2)
    expect(dimensions.width).to be > (webdriver.browser_size.x / 2)
  end
end
