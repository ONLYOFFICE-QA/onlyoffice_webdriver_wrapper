# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#current_url' do
  let(:webdriver) { described_class.new(:chrome) }

  iframe_js = "var ifr = document.createElement('iframe');" \
              "ifr.src = 'https://www.example.com/';" \
              "ifr.id = 'my-frame';document.body.appendChild(ifr)"

  after { webdriver.quit }

  it 'Opening url in new tab for ftp site will not cause forever loop' do
    webdriver.open(local_file('link_to_ftp.html'))
    webdriver.click_on_locator('//a')
    webdriver.choose_tab(2)
    expect { webdriver.current_url }.to raise_error(Net::ReadTimeout)
  end

  it 'current_url in frame return url of frame, not mail url' do
    webdriver.open('https://www.google.com')
    webdriver.execute_javascript(iframe_js, wait_timeout: 5)
    webdriver.select_frame('//*[@id="my-frame"]')
    expect(webdriver.current_url).to eq('https://www.example.com/')
  end
end
