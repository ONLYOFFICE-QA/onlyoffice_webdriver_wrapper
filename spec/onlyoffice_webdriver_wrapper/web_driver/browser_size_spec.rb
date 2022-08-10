# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#browser_size' do
  let(:webdriver) { described_class.new(:chrome) }

  after do
    webdriver.quit
  end

  it 'Check for browser size x is same as headless' do
    expect(webdriver.browser_size.x).to eq(webdriver.headless.resolution_x)
  end

  it 'Check for browser size y is same as headless' do
    expect(webdriver.browser_size.y).to eq(webdriver.headless.resolution_y)
  end
end
