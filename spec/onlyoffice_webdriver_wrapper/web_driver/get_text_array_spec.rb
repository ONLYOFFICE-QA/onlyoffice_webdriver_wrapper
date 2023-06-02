# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_text_array' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('get_text_array.html'))
  end

  after { webdriver.quit }

  it 'get_text_array return empty array for non-existing xpath' do
    expect(webdriver.get_text_array('//div')).to be_empty
  end

  it 'get_text_array return text list for existing elements' do
    expect(webdriver.get_text_array('//span')).to eq(%w[foo bar])
  end
end
