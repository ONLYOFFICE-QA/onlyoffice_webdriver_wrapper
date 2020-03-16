# frozen_string_literal: true

require 'rspec'

describe '#style_helper' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'style_helper.html')
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

  describe '#set_style_parameter' do
    it '#set_style_parameter for existing attribute is correct' do
      webdriver.set_style_parameter('//div', 'display', 'none')
      expect(webdriver.get_style_parameter('//div', 'display')).to eq('none')
    end

    it '#set_style_parameter can-not create new attribute' do
      webdriver.set_style_parameter('//div', 'foo', 'bar')
      expect(webdriver.get_style_parameter('//div', 'foo')).to be_nil
    end
  end

  describe '#set_style_attribute' do
    it '#set_style_attribute for existing attribute is correct' do
      webdriver.set_style_attribute('//div', 'display', 'none')
      expect(webdriver.get_style_parameter('//div', 'display')).to eq('none')
    end

    it '#set_style_attribute can-not create new attribute' do
      webdriver.set_style_attribute('//div', 'foo', 'bar')
      expect(webdriver.get_style_parameter('//div', 'foo')).to be_nil
    end
  end
end
