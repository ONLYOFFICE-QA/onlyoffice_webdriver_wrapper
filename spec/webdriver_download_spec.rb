# frozen_string_literal: true

require 'rspec'

describe 'Working with download directory' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  it 'download directory is deleted after browser stop' do
    download_dir = webdriver.download_directory
    expect(Dir).to exist(download_dir)
    webdriver.quit
    expect(Dir).not_to exist(download_dir)
  end
end
