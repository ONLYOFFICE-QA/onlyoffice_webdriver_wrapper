# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#open_dropdown_selector' do
  webdriver = nil

  after { webdriver.quit }

  it 'opening dropdown selector works in chrome' do
    webdriver = described_class.new(:chrome)
    webdriver.open(local_file('open_dropdown_selector.html'))
    webdriver.open_dropdown_selector('//div')
    expect(webdriver).to be_element_visible('//li')
  end

  it 'opening dropdown selector works in firefox' do
    webdriver = described_class.new(:firefox)
    webdriver.open(local_file('open_dropdown_selector.html'))
    webdriver.open_dropdown_selector('//div')
    expect(webdriver).to be_element_visible('//li')
  end
end
