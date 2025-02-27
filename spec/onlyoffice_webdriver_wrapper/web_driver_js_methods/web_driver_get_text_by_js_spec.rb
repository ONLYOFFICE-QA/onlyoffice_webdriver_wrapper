# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_text_by_js' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('get_text_by_js.html'))
  end

  after { webdriver.quit }

  it 'get_text_by_js return text in label' do
    expect(webdriver.get_text_by_js('//label')).to eq('text_in_label')
  end

  it 'get_text_by_js return text in input' do
    expect(webdriver.get_text_by_js('//input')).to eq('text_in_input')
  end

  it 'get_text_by_js can get to xpath with double quotes' do
    xpath = '//input[@id="foo"]'
    expect(webdriver.get_text_by_js(xpath)).to eq('foo_input')
  end

  it 'get_text_by_js can get to xpath with single quotes' do
    xpath = "//input[@id='foo']"
    expect(webdriver.get_text_by_js(xpath)).to eq('foo_input')
  end
end
