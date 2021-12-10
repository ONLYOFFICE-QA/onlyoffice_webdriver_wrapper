# frozen_string_literal: true

require 'rspec'

describe 'OnlyofficeWebdriverWrapper::WebDriver#switch_to_popup' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  it 'Calling webdriver method on popup window until it stopped loading not cause it never load' do
    file_with_popup = "#{Dir.pwd}/spec/html_examples/switch_to_popup_get_element.html"
    webdriver.open("file://#{file_with_popup}")
    webdriver.click_on_locator('//a')
    webdriver.switch_to_popup
    expect(webdriver.get_url).not_to be_empty
  end

  after { webdriver.quit }
end
