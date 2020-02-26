# frozen_string_literal: true

require 'spec_helper'

describe 'wait_until' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  wait_until_message = '`return document.readyState;` with result: `complete`'

  it 'wait_until by default wait for js load' do
    webdriver.open('http://127.0.0.1')
    expect do
      webdriver.wait_until do
        true
      end
    end.to output(/#{wait_until_message}/).to_stdout
  end

  it 'wait_until wait_js: false will not wait for js load' do
    webdriver.open('http://127.0.0.1')
    expect do
      webdriver.wait_until(::PageObject.default_page_wait, nil, wait_js: false) do
        true
      end
    end.not_to output(/#{wait_until_message}/).to_stdout
  end

  after { webdriver.quit }
end
