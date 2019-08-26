# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  it 'Quiting several times not cause any troubles' do
    webdriver.quit
    expect { webdriver.quit }.not_to output(/error/).to_stdout
  end
end
