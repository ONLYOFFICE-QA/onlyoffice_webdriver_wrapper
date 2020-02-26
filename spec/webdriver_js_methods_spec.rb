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
                                    'content')).to eq('with_pseudo_')
  end

  describe 'WebdriverJsMethods#remove_element' do
    before do
      webdriver.open("file://#{pseudo_class_file}")
    end

    it 'WebdriverJsMethods#remove_element works for xpath with single quote' do
      element_to_remove = "//*[@id='first_element']"
      webdriver.remove_element(element_to_remove)
      expect(webdriver.get_element(element_to_remove)).to be_nil
    end

    it 'WebdriverJsMethods#remove_element works for xpath with double quote' do
      element_to_remove = '//*[@id="first_element"]'
      webdriver.remove_element(element_to_remove)
      expect(webdriver.get_element(element_to_remove)).to be_nil
    end
  end

  it 'WebdriverJsMethods#element_size_by_js return not empty data' do
    webdriver.open("file://#{pseudo_class_file}")
    size = webdriver.element_size_by_js('//*[@id="first_element"]')
    expect(size.x).to be > 0
    expect(size.y).to be > 0
  end

  it 'WebdriverJsMethods#object_absolute_position return not empty data' do
    webdriver.open("file://#{pseudo_class_file}")
    size = webdriver.object_absolute_position('//*[@id="first_element"]')
    expect(size.x).to be > 0
    expect(size.y).to be > 0
  end
end
