# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#open' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'open correct works for non existing page' do
    non_existing_url = 'http://192.168.3.3'
    expect { webdriver.open(non_existing_url) }
      .to raise_error(Net::ReadTimeout, /#{non_existing_url}/)
  end

  it 'open correct works for public internet page' do
    url = 'https://google.com'
    expect(webdriver.open(url)).to be_nil
  end

  it 'open correct works for local files' do
    url = "file://#{__FILE__}"
    expect(webdriver.open(url)).to be_nil
  end
end
