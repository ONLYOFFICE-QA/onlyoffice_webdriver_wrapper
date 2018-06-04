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

  after do
    webdriver.quit
  end
end
