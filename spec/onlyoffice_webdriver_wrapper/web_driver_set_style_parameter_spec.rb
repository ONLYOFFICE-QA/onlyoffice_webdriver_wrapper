# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#set_style_parameter' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'set_style_parameter.html')
  end

  after { webdriver.quit }

  it '#set_style_parameter for existing attribute is correct' do
    webdriver.set_style_parameter('//div', 'display', 'none')
    expect(webdriver.get_style_parameter('//div', 'display')).to eq('none')
  end

  it '#set_style_parameter can-not create new attribute' do
    webdriver.set_style_parameter('//div', 'foo', 'bar')
    expect(webdriver.get_style_parameter('//div', 'foo')).to be_nil
  end
end
