# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#wait_until_element_disappear' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:element_xpath) { '//div[@id="forDelete"]' }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'wait_until_element_disappear.html')
  end

  after { webdriver.quit }

  it 'wait_until_element_disappear return true with default timeout' do
    expect(webdriver.wait_until_element_disappear(element_xpath)).to be_truthy
  end

  it 'wait_until_element_disappear fail with to small timeout' do
    expect { webdriver.wait_until_element_disappear(element_xpath, timeout: 1) }
      .to raise_error(Selenium::WebDriver::Error::TimeoutError)
  end
end
