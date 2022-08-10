# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#browser_metadata' do
  webdriver = nil

  it 'Get Firefox Metadata' do
    webdriver = described_class.new(:firefox)
    expect(webdriver.browser_metadata).to include('firefox')
  end

  it 'Get Chrome Metadata' do
    webdriver = described_class.new(:chrome)
    expect(webdriver.browser_metadata).to include('chrome')
  end

  after do
    webdriver.quit
  end
end
