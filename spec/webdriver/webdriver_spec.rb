require 'rspec'
require_relative '../../testing_shared'

describe WebDriver do
  let(:webdriver) { WebDriver.new(:chrome) }

  it 'Check for popup open' do
    webdriver.new_tab
    expect(webdriver.tab_count).to eq(2)
  end

  it 'choose_tab' do
    expect { webdriver.choose_tab(2) }.to raise_error(RuntimeError, /choose_tab: Tab number = 2 not found/)
  end


  it 'Check for browser size' do
    expect(webdriver.browser_size.x).to eq(webdriver.headless.resolution_x)
    expect(webdriver.browser_size.y).to eq(webdriver.headless.resolution_y)
  end

  after { webdriver.quit }
end
