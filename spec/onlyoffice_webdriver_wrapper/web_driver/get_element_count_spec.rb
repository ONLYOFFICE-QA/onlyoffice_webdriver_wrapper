# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_element_count' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('get_element_count.html'))
  end

  after { webdriver.quit }

  it 'get_element_count return 0 for non-existing element' do
    expect(webdriver.get_element_count('//foo')).to eq(0)
  end

  it 'get_element_count return count of all visible elements' do
    expect(webdriver.get_element_count('//span')).to eq(2)
  end

  it 'get_element_count return only visible elements for partly hidden' do
    expect(webdriver.get_element_count('//div')).to eq(1)
  end

  it 'get_element_count return all elements for partly hidden' do
    expect(webdriver.get_element_count('//div', false)).to eq(2)
  end
end
