# frozen_string_literal: true

require 'rspec'

describe OnlyofficeWebdriverWrapper::WebDriver, '#click_on_locator count' do
  let(:click_count) { 10 }
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('click_counter.html'))
  end

  after { webdriver.quit }

  it 'click_on_locator with count 2 should not be double click' do
    webdriver.click_on_locator('//button', false, count: 2)
    expect(webdriver.get_text('//*[@id="demo"]')).to eq('2')
  end

  it 'A lot of click correctly counted by action' do
    webdriver.click_on_locator('//button', false, count: click_count)
    expect(webdriver.get_text('//*[@id="demo"]')).to eq('10')
  end

  it 'A lot of click correctly counted by javascript' do
    webdriver.click_on_locator('//button', true, count: click_count)
    expect(webdriver.get_text('//*[@id="demo"]')).to eq('10')
  end
end
