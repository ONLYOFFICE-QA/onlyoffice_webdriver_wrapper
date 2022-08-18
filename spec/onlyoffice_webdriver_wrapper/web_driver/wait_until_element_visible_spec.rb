# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#wait_until_element_visible' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:hidden_element) { '//div[@id="hidden"]' }

  before do
    webdriver.open(local_file('wait_until_element_visible.html'))
  end

  after { webdriver.quit }

  it 'wait_until_element_visible return true for element which will shown after timeout' do
    expect(webdriver.wait_until_element_visible(hidden_element)).to be_truthy
  end

  it 'wait_until_element_visible raise an error if element not shown' do
    timeout = 1
    expect { webdriver.wait_until_element_visible(hidden_element, timeout) }
      .to raise_error(RuntimeError,
                      /not visible for #{timeout} seconds/)
  end
end
