# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_element_index' do
  let(:webdriver) { described_class.new(:chrome) }

  before { webdriver.open(local_file('get_element_count.html')) }

  after { webdriver.quit }

  it 'get_element_index works for several elements' do
    page = CurrentPagePageObject.new(webdriver)
    expect(webdriver.get_element_index('bar', page.spans_elements)).to eq(1)
  end

  it 'get_element_index return nil for unknown text' do
    page = CurrentPagePageObject.new(webdriver)
    expect(webdriver.get_element_index('fake-text', page.spans_elements)).to be_nil
  end
end
