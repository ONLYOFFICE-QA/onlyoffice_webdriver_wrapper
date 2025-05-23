# frozen_string_literal: true

require 'rspec'

describe OnlyofficeWebdriverWrapper::WebDriver, '#download' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:docx_file) { "#{Dir.pwd}/spec/html_examples/test.docx" }

  after { webdriver.quit }

  it 'download directory is exists after browser start' do
    download_dir = webdriver.download_directory
    expect(Dir).to exist(download_dir)
  end

  it 'download directory is deleted after browser stop' do
    download_dir = webdriver.download_directory
    webdriver.quit
    expect(Dir).not_to exist(download_dir)
  end

  it 'check if file downloaded in correct directory' do
    webdriver.open(local_file('test.docx'))
    expect(webdriver.wait_file_for_download(File.basename(docx_file))).to be_truthy
  end

  it 'check that if now download started error will be correct' do
    fake_file_name = 'fake_file.docx'
    timeout = 5
    expect { webdriver.wait_file_for_download(fake_file_name, timeout) }
      .to raise_error(RuntimeError, /#{fake_file_name} not download for #{timeout} seconds/)
  end
end
