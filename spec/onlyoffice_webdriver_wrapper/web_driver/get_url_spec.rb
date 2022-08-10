# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_url' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'Opening url in new tab for ftp site will not cause forever loop' do
    webdriver.open(local_file('link_to_ftp.html'))
    webdriver.click_on_locator('//a')
    webdriver.choose_tab(2)
    expect { webdriver.get_url }.to raise_error(Net::ReadTimeout)
  end
end
