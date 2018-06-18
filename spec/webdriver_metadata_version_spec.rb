require 'spec_helper'

describe 'Webdriver#browser_metadata' do
  it 'Get Firefox Metadata' do
    @webdriver = OnlyofficeWebdriverWrapper::WebDriver.new(:firefox)
    expect(@webdriver.browser_metadata).to include('firefox')
  end

  it 'Get Chrome Metadata' do
    @webdriver = OnlyofficeWebdriverWrapper::WebDriver.new(:chrome)
    expect(@webdriver.browser_metadata).to include('chrome')
  end

  after do
    @webdriver.quit
  end
end
