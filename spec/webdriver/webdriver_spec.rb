require 'rspec'
require_relative '../../testing_shared'

describe WebDriver do
  it 'Check for popup open' do
    webdriver = WebDriver.new(:chrome)
    webdriver.new_tab
    expect(webdriver.tab_count).to eq(2)
  end
end
