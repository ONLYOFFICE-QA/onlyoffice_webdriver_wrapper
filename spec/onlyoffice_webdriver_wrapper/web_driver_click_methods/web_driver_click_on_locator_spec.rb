# frozen_string_literal: true

require 'rspec'

describe OnlyofficeWebdriverWrapper::WebDriver, '#click_on_locator' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:element_to_show) { '//*[@id="newElement"]' }

  before do
    webdriver.open(local_file('element_appear_after_click.html'))
  end

  after { webdriver.quit }

  it 'click_on_locator can correct click via JS on xpath with single quotes' do
    webdriver.click_on_locator("//button[@id='button']", true)
    expect(webdriver.get_element('//*[@id="newElement"]')).not_to be_nil
  end

  it 'click_on_locator can correct click via JS on xpath with double quotes' do
    webdriver.click_on_locator('//button[@id="button"]', true)
    expect(webdriver.get_element('//*[@id="newElement"]')).not_to be_nil
  end

  it 'click_on_locator fails for invisible element with correct exception' do
    expect { webdriver.click_on_locator(element_to_show) }
      .to raise_error(Selenium::WebDriver::Error::ElementNotInteractableError, /not visible/)
  end

  it 'click_on_locator fails if other element hide element to click' do
    webdriver.open(local_file('element_to_click_hidden_by_other.html'))
    expect { webdriver.click_on_locator('//button') }
      .to raise_error(Selenium::WebDriver::Error::ElementClickInterceptedError, /click intercepted/)
  end
end
