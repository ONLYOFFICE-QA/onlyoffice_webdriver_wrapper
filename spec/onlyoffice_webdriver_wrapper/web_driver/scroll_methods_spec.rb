# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#scroll_methods' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:xpath) { '//*[@id="scroller"]' }

  before do
    webdriver.open(local_file('scroll_methods.html'))
  end

  after do
    webdriver.quit
  end

  it 'current_scroll_position is zero by default' do
    expect(webdriver.current_scroll_position(xpath)).to eq(0)
  end

  it 'current_scroll_position is change to same value as scrolled' do
    value_to_scroll = 25
    webdriver.scroll_list_by_pixels(xpath, value_to_scroll)
    expect(webdriver.current_scroll_position(xpath)).to eq(value_to_scroll)
  end
end
