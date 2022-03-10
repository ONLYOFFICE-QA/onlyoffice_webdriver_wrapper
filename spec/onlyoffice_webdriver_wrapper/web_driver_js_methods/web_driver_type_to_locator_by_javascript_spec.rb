# frozen_string_literal: true

require 'rspec'

describe OnlyofficeWebdriverWrapper::WebDriver, '#type_to_locator_by_javascript' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'type_to_locator_by_javascript send correct data' do
    webdriver.open('https://github.com/login')
    webdriver.type_to_locator('//*[@id="login_field"]', 'user@example.com')
    expect(webdriver.get_text('//*[@id="login_field"]')).to eq('user@example.com')
  end
end
