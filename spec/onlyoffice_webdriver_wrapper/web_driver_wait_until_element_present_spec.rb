# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#wait_until_element_present' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:element_xpath) { '//div[@id="newElement"]' }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'wait_until_element_present.html')
  end

  after { webdriver.quit }

  it 'wait_until_element_present return true with default timeout' do
    expect(webdriver.wait_until_element_present(element_xpath)).to be_truthy
  end

  it 'wait_until_element_present fail with to small timeout' do
    expect { webdriver.wait_until_element_present(element_xpath, timeout: 1) }
      .to raise_error(Selenium::WebDriver::Error::TimeoutError)
  end
end
