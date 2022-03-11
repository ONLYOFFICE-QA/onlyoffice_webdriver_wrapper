# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#cleanup_download_folder' do
  it 'cleanup_download_folder will no delete folder in home folder' do
    temp_dir = '~/onlyoffice_webdriver_wrapper-fake-tmp-dir'
    FileUtils.mkdir_p(temp_dir)
    webdriver = described_class.new(:chrome, download_directory: temp_dir)
    expect { webdriver.cleanup_download_folder }.to output(/is not at tmp dir/).to_stdout
    webdriver.quit
    FileUtils.rmdir(temp_dir)
  end
end
