# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#select_combo_box' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:page) { CurrentPagePageObject.new(webdriver) }
  let(:option_to_select) { 'Opel' }

  after { webdriver.quit }

  before do
    webdriver.open(local_file('select_from_list_elements.html'))
  end

  it 'select_combo_box can be selected by value' do
    webdriver.select_combo_box('//select', 'opel')
    expect(page.car_select).to eq(option_to_select)
  end

  it 'select_combo_box can be select by text' do
    webdriver.select_combo_box('//select', option_to_select, :text)
    expect(page.car_select).to eq(option_to_select)
  end

  it 'select_combo_box fails if there is no such option' do
    fake_text = 'Fake-Entry'
    expect { webdriver.select_combo_box('//select', 'Fake-Entry') }
      .to raise_error(Selenium::WebDriver::Error::NoSuchElementError,
                      "cannot locate element with text: \"#{fake_text}\"")
  end
end
