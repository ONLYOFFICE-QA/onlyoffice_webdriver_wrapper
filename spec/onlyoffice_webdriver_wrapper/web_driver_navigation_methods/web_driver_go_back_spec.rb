# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#go_back' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'go_back return to previous url' do
    url_to_open = 'https://www.google.com/'
    webdriver.open(url_to_open)
    webdriver.open('https://github.com')
    webdriver.go_back
    expect(webdriver.get_url).to eq(url_to_open)
  end
end
