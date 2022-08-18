# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#chrome_version_helper' do
  include OnlyofficeWebdriverWrapper::ChromeVersionHelper

  it 'chrome_version return some non-zero major version for default config' do
    expect(chrome_version.to_s).not_to start_with('0.')
  end

  it 'chrome_version return 0 version for unknown exe' do
    expect(chrome_version('fake-exe').to_s).to start_with('0.')
  end

  it 'chromedriver_path return path for mac' do
    expect(chromedriver_path(:mac)).to be_a(String)
  end

  it 'chromedriver_path return path for linux' do
    expect(chromedriver_path(:linux)).to be_a(String)
  end
end
