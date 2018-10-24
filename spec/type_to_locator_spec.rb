require 'rspec'

describe 'OnlyofficeWebdriverWrapper::WebDriver#type_to_locator' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  it 'type_to_locator without click enter password in correct field' do
    webdriver.open('https://github.com/login')
    webdriver.type_to_locator('//*[@id="login_field"]', 'user@example.com')
    webdriver.type_to_locator('//*[@id="password"]', 'password')
    expect(webdriver.get_text('//*[@id="login_field"]')).to eq('user@example.com')
    expect(webdriver.get_text('//*[@id="password"]')).to eq('password')
  end

  after { webdriver.quit }
end
