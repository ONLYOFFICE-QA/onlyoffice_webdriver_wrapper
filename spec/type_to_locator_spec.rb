# frozen_string_literal: true

require 'rspec'

describe 'OnlyofficeWebdriverWrapper::WebDriver#type_to_locator' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  before do
    webdriver.open('https://github.com/login')
  end

  it 'type_to_locator without click enter password in correct field' do
    webdriver.type_to_locator('//*[@id="login_field"]', 'user@example.com')
    webdriver.type_to_locator('//*[@id="password"]', 'password')
    expect(webdriver.get_text('//*[@id="login_field"]')).not_to eq('user@example.com')
    expect(webdriver.get_text('//*[@id="password"]')).not_to eq('password')

    webdriver.type_to_locator('//*[@id="login_field"]', 'user@example.com', true, true)
    webdriver.type_to_locator('//*[@id="password"]', 'password', true, true)
    expect(webdriver.get_text('//*[@id="login_field"]')).to eq('user@example.com')
    expect(webdriver.get_text('//*[@id="password"]')).to eq('password')
  end

  it 'type_to_locator combination with control get no input in locator' do
    webdriver.type_to_locator('//*[@id="login_field"]', 'pipa')
    webdriver.type_to_locator('//*[@id="login_field"]', [:control, 'a'])
    expect(webdriver.get_text('//*[@id="login_field"]')).to be_empty
  end

  after { webdriver.quit }
end
