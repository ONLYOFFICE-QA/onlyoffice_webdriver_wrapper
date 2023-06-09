# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#action_on_locator_coordinates' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:canvas_xpath) { '//canvas' }

  before do
    webdriver.open(local_file('action_on_locator_coordinates.html'))
  end

  after { webdriver.quit }

  it 'Single click on button' do
    webdriver.action_on_locator_coordinates(canvas_xpath, 50, 50)
    expect(webdriver.alert_text).to eq('Single click')
  end

  it 'Double click on button' do
    webdriver.action_on_locator_coordinates(canvas_xpath,
                                            180,
                                            50,
                                            :double_click)
    expect(webdriver.alert_text).to eq('Double click')
  end
end
