# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#set_style_attribute' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'style_helper.html')
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
end
