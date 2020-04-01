# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#one_of_several_elements_displayed?' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'get_element_count.html')
  end

  it 'one_of_several_elements_displayed? is correct for non-existing element' do
    expect(webdriver).not_to be_one_of_several_elements_displayed('//foo')
  end

  it 'one_of_several_elements_displayed? is correct for shown elements' do
    expect(webdriver).to be_one_of_several_elements_displayed('//div')
  end

  it 'one_of_several_elements_displayed? is correct for partly hidden elements' do
    expect(webdriver).to be_one_of_several_elements_displayed('//span')
  end

  it 'one_of_several_elements_displayed? is correct for hidden elements' do
    expect(webdriver).not_to be_one_of_several_elements_displayed('//input')
  end
end
