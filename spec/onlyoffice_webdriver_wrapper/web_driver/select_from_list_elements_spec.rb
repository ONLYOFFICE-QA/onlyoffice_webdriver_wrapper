# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#select_from_list_elements' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'select_from_list_elements really selects some entries' do
    option_to_select = 'Opel'
    webdriver.open(local_file('select_from_list_elements.html'))
    page = CurrentPagePageObject.new(webdriver)
    webdriver.select_from_list_elements(option_to_select, page.car_elements_elements)
    expect(page.car_select).to eq(option_to_select)
  end
end
