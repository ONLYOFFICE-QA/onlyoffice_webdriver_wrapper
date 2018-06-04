require 'spec_helper'

describe 'Webdriver Firefox' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:firefox) }

  it 'Check That firefox start correctly' do
    expect { webdriver }.not_to raise_error
  end

  it 'Check That firefox correctly responde to #alert_exists?' do
    webdriver.open('www.google.com')
    expect(webdriver).not_to be_alert_exists
  end

  it 'Check That firefox return empty browser logs' do
    expect(webdriver.browser_logs).to be_empty
  end

  it 'open url and get console log output' do
    pending('https://github.com/mozilla/geckodriver/issues/284')
    file_with_js_error = "#{Dir.pwd}/spec/html_examples/javascript_error.html"
    webdriver.open("file://#{file_with_js_error}")
    webdriver.wait_until { webdriver.document_ready? }
    expect(webdriver.browser_logs).not_to be_empty
  end

  after do
    webdriver.quit
  end
end
