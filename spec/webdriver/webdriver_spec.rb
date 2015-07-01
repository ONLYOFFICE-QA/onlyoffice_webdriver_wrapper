require 'rspec'
require_relative '../../testing_shared'

describe WebDriver do
  it 'Check for popup open' do
    webdriver = WebDriver.new(:chrome)
    webdriver.new_tab
    expect(webdriver.tab_count).to eq(2)
  end

  it 'Check for browser size' do
    webdriver = WebDriver.new(:chrome)
    expect(webdriver.browser_size.x).to eq(webdriver.headless.resolution_x)
    expect(webdriver.browser_size.y).to eq(webdriver.headless.resolution_y)
  end
end
