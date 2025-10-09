# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#refresh' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'refresh stay on same url' do
    url_to_open = 'https://www.google.com/'
    webdriver.open(url_to_open)
    webdriver.refresh
    expect(webdriver.current_url).to include(url_to_open)
  end
end
