# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#firefox' do
  let(:webdriver) { described_class.new(:firefox) }

  after do
    webdriver.quit
  end

  it 'Check That firefox start correctly' do
    expect { webdriver }.not_to raise_error
  end

  it 'Check That firefox correctly respond to #alert_exists?' do
    webdriver.open('www.google.com')
    expect(webdriver).not_to be_alert_exists
  end

  it 'Webdriver#click_on_locator_coordinates correct for .0 values' do
    webdriver.open(local_file('web_driver_element_size_by_js_spec.html'))
    webdriver.click_on_locator_coordinates('//div', 20.0, 10)
    expect(webdriver.browser_logs).to be_empty
  end

  it 'Check That firefox return empty browser logs' do
    expect(webdriver.browser_logs).to be_empty
  end

  it 'open url and get console log output' do
    pending('https://github.com/mozilla/geckodriver/issues/284')
    webdriver.open(local_file('javascript_error.html'))

    webdriver.wait_until { webdriver.document_ready? }
    expect(webdriver.browser_logs).not_to be_empty
  end

  it 'Check that firefox can download files by direct links' do
    result = webdriver.download('https://onlyoffice-webdriver-wrapper-spec-files.s3.amazonaws.com/0+(1).docx')
    expect(File).to exist(result)
  end
end
