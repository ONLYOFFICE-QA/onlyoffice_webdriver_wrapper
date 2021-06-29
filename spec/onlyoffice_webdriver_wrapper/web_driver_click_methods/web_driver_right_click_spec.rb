# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#right_click' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'right_click_alert.html')
  end

  after { webdriver.quit }

  it 'right_click on element show alert' do
    webdriver.right_click('//body')
    expect(webdriver).to be_alert_exists
  end
end
