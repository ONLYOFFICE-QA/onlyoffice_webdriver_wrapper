# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#set_style_attribute' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'set_style_attribute.html')
  end

  after { webdriver.quit }

  it '#set_style_attribute for existing attribute is correct' do
    webdriver.set_style_attribute('//div', 'display', 'none')
    expect(webdriver.get_style_parameter('//div', 'display')).to eq('none')
  end

  it '#set_style_attribute can-not create new attribute' do
    webdriver.set_style_attribute('//div', 'foo', 'bar')
    expect(webdriver.get_style_parameter('//div', 'foo')).to be_nil
  end

  describe 'quotes in xpath' do
    it '#set_style_attribute for xpath with single quotes' do
      xpath = "//div[@id='foo']"
      webdriver.set_style_attribute(xpath, 'display', 'none')
      expect(webdriver.get_style_parameter(xpath, 'display')).to eq('none')
    end

    it '#set_style_attribute for xpath with double quotes' do
      xpath = '//div[@id="foo"]'
      webdriver.set_style_attribute(xpath, 'display', 'none')
      expect(webdriver.get_style_parameter(xpath, 'display')).to eq('none')
    end
  end
end
