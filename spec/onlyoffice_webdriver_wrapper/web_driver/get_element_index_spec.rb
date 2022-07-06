# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_element_index' do
  let(:webdriver) { described_class.new(:chrome) }

  before { webdriver.open(local_file('get_element_count.html')) }

  after { webdriver.quit }

  it 'get_element_index works for several elements' do
    page = CurrentPagePageObject.new(webdriver)
    expect(webdriver.get_element_index('bar', page.spans)).to eq(1)
  end
end
