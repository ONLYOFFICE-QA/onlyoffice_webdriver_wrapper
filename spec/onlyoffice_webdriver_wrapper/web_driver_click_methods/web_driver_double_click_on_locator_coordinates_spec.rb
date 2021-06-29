# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#double_click_on_locator_coordinates' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'double_click_alert.html')
  end

  after { webdriver.quit }

  it 'double_click_on_locator_coordinates with nil coordinates' do
    webdriver.double_click_on_locator_coordinates('//body', nil, nil)
    expect(webdriver).to be_alert_exists
  end

  it 'double_click_on_locator_coordinates with some coordinates' do
    webdriver.double_click_on_locator_coordinates('//body', 100, 100)
    expect(webdriver).to be_alert_exists
  end
end
