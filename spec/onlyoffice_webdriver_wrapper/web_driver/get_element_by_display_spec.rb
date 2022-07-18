# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_element_by_display' do
  let(:webdriver) { described_class.new(:chrome) }

  before { webdriver.open(local_file('get_element_by_display.html')) }

  after { webdriver.quit }

  it 'get_element_by_display return displayed element' do
    element = webdriver.get_element_by_display('//div')
    expect(webdriver.get_text(element)).to eq('Visible')
  end

  it 'get_element_by_display return empty if there is no elements' do
    expect(webdriver.get_element_by_display('//foo')).to be_empty
  end

  it 'get_element_by_display return first element if there is several displayed' do
    element = webdriver.get_element_by_display('//span')
    expect(webdriver.get_text(element)).to eq('Visible1')
  end

  it 'get_element_by_display raise an error for unknown xpath' do
    expect { webdriver.get_element_by_display("'") }
      .to raise_error(Selenium::WebDriver::Error::InvalidSelectorError, /Invalid Selector/)
  end
end
