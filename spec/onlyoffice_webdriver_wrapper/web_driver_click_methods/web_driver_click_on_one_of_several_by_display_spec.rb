# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#click_on_one_of_several_by_display' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'click_on_one_of_several_by_display.html')
  end

  after { webdriver.quit }

  it 'click_on_one_of_several_by_display return false if no elements found' do
    expect(webdriver.click_on_one_of_several_by_display('//foo')).to be_falsey
  end

  it 'click_on_one_of_several_by_display correct click on element' do
    webdriver.click_on_one_of_several_by_display('//button')
    expect(webdriver.get_element('//*[@id="newElement"]')).not_to be_nil
  end
end
