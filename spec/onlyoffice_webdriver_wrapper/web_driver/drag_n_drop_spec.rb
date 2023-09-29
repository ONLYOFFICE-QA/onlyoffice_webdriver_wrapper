# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#drag_n_drop' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('drag_n_drop.html'))
  end

  after { webdriver.quit }

  it 'drag and drop element' do
    x_value = 150
    y_value = 100
    webdriver.drag_and_drop('//canvas', 10, 10, x_value, y_value)
    expect(webdriver.get_text('//span[@id="coordinates"]')).to eq("X: #{x_value}, Y: #{y_value}")
  end

  it 'drag and drop finish process by default' do
    webdriver.drag_and_drop('//canvas', 10, 10, 150, 100)
    expect(webdriver.get_text('//span[@id="dragInProgress"]')).to eq('No')
  end

  it 'drag and drop do not finish process if specified' do
    webdriver.drag_and_drop('//canvas', 10, 10, 150, 100, mouse_release: false)
    expect(webdriver.get_text('//span[@id="dragInProgress"]')).to eq('Yes')
  end
end
