# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#wait_until' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('remove_attribute.html'))
  end

  after { webdriver.quit }

  it 'wait_until element failed if element not found' do
    expect do
      webdriver.wait_until(1) do
        webdriver.element_present?('//fake')
      end
    end.to raise_error(RuntimeError, /Wait until timeout/)
  end

  it 'wait_until error if js alert is present' do
    webdriver.open(local_file('alert.html'))
    expect do
      webdriver.wait_until(1) { webdriver.execute_javascript('a') }
    end.to raise_error(Selenium::WebDriver::Error::UnexpectedAlertOpenError, /JS Alert Happened/)
  end

  it 'wait_until for stale element' do
    element = webdriver.get_element('//div')
    webdriver.execute_javascript('document.getElementById("foo").remove();')
    expect do
      webdriver.wait_until(1) { element.attribute('id') }
    end.to raise_error(RuntimeError, /Wait until: rescuing from Stale Element error failed after 3 tries/)
  end
end
