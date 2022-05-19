# frozen_string_literal: true

require 'rspec'

describe OnlyofficeWebdriverWrapper::WebDriver, '#type_to_locator_by_javascript' do
  let(:webdriver) { described_class.new(:chrome) }

  before { webdriver.open('https://github.com/login') }

  after { webdriver.quit }

  it 'type_to_locator_by_javascript send correct data' do
    webdriver.type_to_locator_by_javascript('//*[@id="login_field"]', 'user@example.com')
    expect(webdriver.get_text('//*[@id="login_field"]')).to eq('user@example.com')
  end

  it 'type_to_locator_by_javascript with \n delete extra symbol' do
    webdriver.type_to_locator_by_javascript('//*[@id="login_field"]', "user@example.com\n")
    expect(webdriver.get_text('//*[@id="login_field"]')).to eq('user@example.com')
  end

  it 'type_to_locator_by_javascript with \n in single quotes insert those symbols' do
    data = 'user@example.com\n'
    webdriver.type_to_locator_by_javascript('//*[@id="login_field"]', data)
    expect(webdriver.get_text('//*[@id="login_field"]')).to eq(data)
  end

  it 'type_to_locator_by_javascript double quotes symbols are ok' do
    data = '"'
    webdriver.type_to_locator_by_javascript('//*[@id="login_field"]', data)
    expect(webdriver.get_text('//*[@id="login_field"]')).to eq(data)
  end

  it 'type_to_locator_by_javascript single quotes symbols are ok' do
    data = "'"
    webdriver.type_to_locator_by_javascript('//*[@id="login_field"]', data)
    expect(webdriver.get_text('//*[@id="login_field"]')).to eq(data)
  end
end
