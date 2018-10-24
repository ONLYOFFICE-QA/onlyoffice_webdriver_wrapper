require 'rspec'

describe 'Working with download directory' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  it 'download directory is deleted after browser stop' do
    download_dir = webdriver.download_directory
    expect(Dir.exist?(download_dir)).to be_truthy
    webdriver.quit
    expect(Dir.exist?(download_dir)).to be_falsey
  end
end
