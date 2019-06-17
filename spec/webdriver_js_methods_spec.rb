# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebdriverJsMethods do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  it 'WebdriverJsMethods#jquery_finished? if no jquery on page' do
    webdriver.open('http://www.google.com')
    expect(webdriver.jquery_finished?).to be_truthy
  end

  it 'WebdriverJsMethods#jquery_finished? if jquery on page' do
    webdriver.open('https://www.teamlab.info')
    expect(webdriver.jquery_finished?).to be_truthy
  end
end
