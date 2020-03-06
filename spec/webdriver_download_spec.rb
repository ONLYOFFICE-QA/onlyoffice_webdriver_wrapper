# frozen_string_literal: true

require 'rspec'

describe 'Working with download directory' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }
  let(:docx_file) { "#{Dir.pwd}/spec/html_examples/test.docx" }

  it 'download directory is deleted after browser stop' do
    download_dir = webdriver.download_directory
    expect(Dir).to exist(download_dir)
    webdriver.quit
    expect(Dir).not_to exist(download_dir)
  end

  it 'check if file downloaded in correct directory' do
    webdriver.open("file://#{docx_file}")
    expect(webdriver.wait_file_for_download(File.basename(docx_file))).to be_truthy
  end
end
