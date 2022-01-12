# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_url' do
  let(:webdriver) { described_class.new(:chrome) }

  it 'Opening url in new tab for ftp site will not cause forever loop' do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'link_to_ftp.html')
    webdriver.click_on_locator('//a')
    webdriver.choose_tab(2)
    webdriver.get_url # TODO: Remove
  end
end
