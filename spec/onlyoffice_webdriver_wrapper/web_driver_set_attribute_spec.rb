# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#set_attribute' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'set_attribute.html')
  end

  after { webdriver.quit }

  it 'Attribute can be set to xpath with double quotes' do
    xpath = '//div[@id="foo"]'
    webdriver.set_attribute(xpath, 'foo', 'bar')
    expect(webdriver.get_attribute(xpath, 'foo')).to eq('bar')
  end

  it 'Attribute can be set to xpath with single quotes' do
    xpath = "//div[@id='foo']"
    webdriver.set_attribute(xpath, 'foo', 'bar')
    expect(webdriver.get_attribute(xpath, 'foo')).to eq('bar')
  end
end
