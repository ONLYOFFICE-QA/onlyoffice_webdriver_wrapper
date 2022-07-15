# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#element_present?' do
  let(:webdriver) { described_class.new(:chrome) }

  before { webdriver.open(local_file('get_element_count.html')) }

  after { webdriver.quit }

  it 'element_present is correct for PageObject element' do
    page = CurrentPagePageObject.new(webdriver)
    expect(webdriver).to be_element_present(page.div_element)
  end
end
