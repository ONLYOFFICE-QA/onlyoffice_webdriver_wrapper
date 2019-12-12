# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebdriverJsMethods do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }
  let(:pseudo_class_file) { "#{Dir.pwd}/spec/html_examples/pseudo_class_test.html" }

  it 'WebdriverJsMethods#jquery_finished? if no jquery on page' do
    webdriver.open('http://www.google.com')
    expect(webdriver.jquery_finished?).to be_truthy
  end

  it 'WebdriverJsMethods#jquery_finished? if jquery on page' do
    webdriver.open('https://www.teamlab.info')
    expect(webdriver.jquery_finished?).to be_truthy
  end

  it 'WebdriverJsMethods#computed_style' do
    webdriver.open("file://#{pseudo_class_file}")
    expect(webdriver.computed_style('//*[@id="first_element"]',
                                    ':before',
                                    'content')).to eq('none')
    expect(webdriver.computed_style('//*[@id="second_element"]',
                                    ':before',
                                    'content')).to eq('"with_pseudo_ "')
  end
end
