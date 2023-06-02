# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_text_of_several_elements' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  before do
    webdriver.open(local_file('get_text_of_several_elements.html'))
  end

  it 'get_text_of_several_elements return array of strings' do
    expect(webdriver.get_text_of_several_elements('//span')).to eq(%w[one two])
  end

  it 'get_text_of_several_elements filter out empty strings' do
    expect(webdriver.get_text_of_several_elements('//span')).not_to include('')
  end
end
