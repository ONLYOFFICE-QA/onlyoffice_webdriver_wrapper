# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#element_visible?' do
  let(:webdriver) { described_class.new(:chrome) }

  before { webdriver.open(local_file('get_element_count.html')) }

  after { webdriver.quit }

  it 'element_visible could be called for PageObject object' do
    page = CurrentPagePageObject.new(webdriver)
    element = webdriver.get_element(page.div_element)
    expect(webdriver).to be_element_visible(element)
  end

  it 'element_visible return false for fake object' do
    element = webdriver.get_element('//fake')
    expect(webdriver).not_to be_element_visible(element)
  end
end
