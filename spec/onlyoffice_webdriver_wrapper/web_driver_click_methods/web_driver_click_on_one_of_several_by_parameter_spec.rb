# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#click_on_one_of_several_by_parameter' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'click_on_one_of_several_by_parameter.html')
  end

  after { webdriver.quit }

  it 'click_on_one_of_several_by_parameter return false if no elements found' do
    expect(webdriver.click_on_one_of_several_by_parameter('//foo', 'foo', 'foo')).to be_falsey
  end

  it 'click_on_one_of_several_by_parameter correct click on element with correct param' do
    webdriver.click_on_one_of_several_by_parameter('//button',
                                                   'foo',
                                                   'bar')
    expect(webdriver.get_element('//*[@id="newElement"]')).not_to be_nil
  end
end
