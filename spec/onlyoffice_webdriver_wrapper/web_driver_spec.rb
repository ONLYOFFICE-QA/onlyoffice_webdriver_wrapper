# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver do
  after { webdriver.quit }

  describe 'Default tests' do
    let(:webdriver) { described_class.new(:chrome) }

    it 'Check for popup open' do
      webdriver.new_tab
      expect(webdriver.tab_count).to eq(2)
    end

    it 'type_to_input raise error for nil' do
      expect do
        webdriver.type_to_input('//*[@id="unknown-id"',
                                'test')
      end.to raise_error(Selenium::WebDriver::Error::NoSuchElementError, /element not found/)
    end
  end

  describe 'User agent' do
    describe 'Custom user agent' do
      let(:webdriver) { described_class.new(:chrome, device: :android_phone) }

      it 'set_custom_device_useragent' do
        expect(webdriver.current_user_agent).to eq(OnlyofficeWebdriverWrapper::WebDriver::USERAGENT_ANDROID_PHONE)
      end
    end

    describe 'Default user agent' do
      let(:webdriver) { described_class.new(:chrome) }

      it 'default device name' do
        expect(webdriver.current_user_agent).not_to eq(OnlyofficeWebdriverWrapper::WebDriver::USERAGENT_ANDROID_PHONE)
      end
    end
  end

  describe 'console log' do
    let(:webdriver) { described_class.new(:chrome) }

    it 'open url and get console log output' do
      webdriver.open(local_file('javascript_error.html'))
      webdriver.wait_until { webdriver.document_ready? }
      expect(webdriver.browser_logs).not_to be_empty
    end
  end
end
