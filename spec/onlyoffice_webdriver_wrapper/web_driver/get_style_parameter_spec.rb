# frozen_string_literal: true

require 'rspec'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_style_parameter' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('style_helper.html'))
  end

  after { webdriver.quit }

  describe '#get_style_parameter' do
    it '#get_style_parameter return existing value' do
      expect(webdriver.get_style_parameter('//div', 'display')).to eq('block')
    end

    it '#get_style_parameter return nil for non-existing param' do
      expect(webdriver.get_style_parameter('//div', 'fake')).to be_nil
    end
  end
end
