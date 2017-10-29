require 'rspec'

describe 'OnlyofficeWebdriverWrapper::WebDriver#click_on_locator' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  it 'click_on_locator with count 2 should not be doubleclick' do
    webdriver.open('https://www.w3schools.com/js/tryit.asp?filename=tryjs_function_counter3')
    webdriver.select_frame('//*[@id="iframeResult"]')
    webdriver.click_on_locator('//button', false, count: 2)
    expect(webdriver.get_text('//*[@id="demo"]')).to eq('2')
  end

  after { webdriver.quit }
end
