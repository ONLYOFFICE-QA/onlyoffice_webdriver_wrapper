# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#javascript_methods' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'WebdriverJsMethods#jquery_finished? if no jquery on page' do
    webdriver.open('http://www.google.com')
    expect(webdriver).to be_jquery_finished
  end

  it 'WebdriverJsMethods#jquery_finished? if jquery on page' do
    webdriver.open('https://onlyoffice.com')
    expect(webdriver).to be_jquery_finished
  end
end
