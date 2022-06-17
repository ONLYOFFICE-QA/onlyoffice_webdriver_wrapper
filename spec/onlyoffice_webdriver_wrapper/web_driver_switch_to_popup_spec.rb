# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#switch_to_popup' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'Calling webdriver method on popup window until it stopped loading not cause it never load' do
    webdriver.open(local_file('switch_to_popup_get_element.html'))
    webdriver.click_on_locator('//a')
    webdriver.switch_to_popup
    expect(webdriver.get_url).not_to be_empty
  end

  it 'switch_to_popup will raise an error if only one tab' do
    expect { webdriver.switch_to_popup(after_switch_timeout: 1, popup_appear_timeout: 1) }
      .to raise_error(RuntimeError, /Popup window not found/)
  end
end
