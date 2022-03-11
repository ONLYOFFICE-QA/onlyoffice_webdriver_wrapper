# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#execute_javascript' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'execute_javascript will raise for incorrect js code' do
    expect { webdriver.execute_javascript('^') }
      .to raise_error(Selenium::WebDriver::Error::JavascriptError, /Exception javascript error/)
  end
end
