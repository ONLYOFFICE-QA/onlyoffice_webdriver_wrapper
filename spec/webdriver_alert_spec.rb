# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver do
  let(:webdriver) { described_class.new(:chrome) }
  let(:no_alert_file) { "#{Dir.pwd}/spec/html_examples/jquery.html" }

  it 'alert_exists? return true for file with alert' do
    webdriver.open(local_file('alert.html'))
    expect(webdriver).to be_alert_exists
  end

  it 'alert_text return text of alert' do
    webdriver.open(local_file('alert.html'))
    expect(webdriver.alert_text).to eq('Hi')
  end

  it 'alert_exists? return false for file without alert' do
    webdriver.open(local_file('jquery.html'))
    expect(webdriver).not_to be_alert_exists
  end
end
