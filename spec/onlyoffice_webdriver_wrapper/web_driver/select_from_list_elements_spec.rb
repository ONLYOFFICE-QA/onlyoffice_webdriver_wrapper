# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#select_from_list_elements' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:page) { CurrentPagePageObject.new(webdriver) }

  after { webdriver.quit }

  before do
    webdriver.open(local_file('select_from_list_elements.html'))
  end

  it 'select_from_list_elements really selects some entries' do
    option_to_select = 'Opel'
    webdriver.select_from_list_elements(option_to_select, page.car_elements_elements)
    expect(page.car_select).to eq(option_to_select)
  end

  it 'select_from_list_elements fails if there is no such object' do
    expect { webdriver.select_from_list_elements('Fake-Entry', page.car_elements_elements) }
      .to raise_error(OnlyofficeWebdriverWrapper::SelectEntryNotFound)
  end
end
