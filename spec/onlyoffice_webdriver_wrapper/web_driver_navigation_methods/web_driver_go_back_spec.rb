# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#go_back' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'go_back return to previous url' do
    url_to_open = local_file('type_helper.html')
    webdriver.open(url_to_open)
    webdriver.open(local_file('set_attribute.html'))
    webdriver.go_back
    expect(webdriver.current_url).to eq(url_to_open)
  end
end
