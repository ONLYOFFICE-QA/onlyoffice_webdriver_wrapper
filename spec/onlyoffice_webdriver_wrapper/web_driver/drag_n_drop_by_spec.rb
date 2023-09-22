# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#drag_n_drop' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('drag_n_drop.html'))
  end

  after { webdriver.quit }

  it 'drag_and_drop_by correctly move element itself' do
    x_value = 150
    y_value = 100
    webdriver.drag_and_drop_by('//div[@id="rectangle"]', x_value, y_value)
    expect(webdriver.get_text('//span[@id="centerCoordinates"]')).to eq("X: #{x_value}, Y: #{y_value}")
  end
end
