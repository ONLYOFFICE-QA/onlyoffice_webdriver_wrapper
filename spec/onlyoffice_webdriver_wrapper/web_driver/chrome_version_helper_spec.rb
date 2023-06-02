# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#chrome_version_helper' do
  include OnlyofficeWebdriverWrapper::ChromeVersionHelper

  describe '#chrome_version' do
    it 'chrome_version returns some non-zero major version for default config' do
      expect(chrome_version.to_s).not_to start_with('0.')
    end

    it 'chrome_version returns 0 version for unknown exe' do
      expect(chrome_version('fake-exe').to_s).to start_with('0.')
    end
  end

  describe '#chromedriver_path' do
    it 'returns path for mac' do
      expect(chromedriver_path(:mac)).to be_a(String)
    end

    it 'returns path for linux' do
      expect(chromedriver_path(:linux)).to be_a(String)
    end
  end

  describe '#chromedriver_path_for_version' do
    it 'returns default path for old version' do
      expect(chromedriver_path_for_version(1)).to eq(default_linux)
    end
  end
end
