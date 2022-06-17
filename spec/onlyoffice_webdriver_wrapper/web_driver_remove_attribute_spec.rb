# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#remove_attribute' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('remove_attribute.html'))
  end

  after { webdriver.quit }

  it 'remove_attribute can be remove for xpath with double quotes' do
    xpath = '//div[@id="foo"]'
    webdriver.remove_attribute(xpath, 'itemid')
    expect(webdriver.get_attribute(xpath, 'itemid')).to be_nil
  end

  it 'remove_attribute can be remove for xpath with single quotes' do
    xpath = "//div[@id='foo']"
    webdriver.remove_attribute(xpath, 'itemid')
    expect(webdriver.get_attribute(xpath, 'itemid')).to be_nil
  end
end
