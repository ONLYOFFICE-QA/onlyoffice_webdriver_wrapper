# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }
  let(:file) { "#{Dir.pwd}/spec/html_examples/jquery.html" }
  let(:button_xpath) { '//*[@id="button"]' }
  let(:custom_class) { 'customClass' }

  before do
    webdriver.open("file://#{file}")
  end

  it 'add_class_by_jquery correctly works' do
    expect(webdriver.get_attribute(button_xpath, 'class')).to be_empty
    webdriver.add_class_by_jquery(button_xpath, custom_class)
    expect(webdriver.get_attribute(button_xpath, 'class')).to eq(custom_class)
  end
end
