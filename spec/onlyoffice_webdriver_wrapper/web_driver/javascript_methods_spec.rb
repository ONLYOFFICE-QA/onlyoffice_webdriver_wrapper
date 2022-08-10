# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#javascript_methods' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'WebdriverJsMethods#jquery_finished? if no jquery on page' do
    webdriver.open('http://www.google.com')
    expect(webdriver).to be_jquery_finished
  end

  it 'WebdriverJsMethods#jquery_finished? if jquery on page' do
    webdriver.open('https://onlyoffice.com')
    expect(webdriver).to be_jquery_finished
  end

  describe 'WebdriverJsMethods#remove_element' do
    before do
      webdriver.open(local_file('pseudo_class_test.html'))
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
end
