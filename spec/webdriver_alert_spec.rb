# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver do
  let(:webdriver) { described_class.new(:chrome) }
  let(:alert_file) { "#{Dir.pwd}/spec/html_examples/alert.html" }
  let(:no_alert_file) { "#{Dir.pwd}/spec/html_examples/jquery.html" }

  it 'alert_exists? return true for file with alert' do
    webdriver.open("file://#{alert_file}")
    expect(webdriver).to be_alert_exists
  end

  it 'alert_text return text of alert' do
    webdriver.open("file://#{alert_file}")
    expect(webdriver.alert_text).to eq('Hi')
  end

  it 'alert_exists? return false for file without alert' do
    webdriver.open("file://#{no_alert_file}")
    expect(webdriver).not_to be_alert_exists
  end
end
