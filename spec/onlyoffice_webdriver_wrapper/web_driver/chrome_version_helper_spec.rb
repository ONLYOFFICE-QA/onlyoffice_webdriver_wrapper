# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#chrome_version_helper' do
  let(:webdriver) { described_class.new(:chrome, do_not_start_browser: true) }

  it 'Chrome version is not zero' do
    expect(webdriver.chrome_version).not_to eq(webdriver.unknown_chrome_version)
  end

  it 'Chrome version for custom command is zero' do
    expect(webdriver.chrome_version('foo')).to eq(webdriver.unknown_chrome_version)
  end
end
