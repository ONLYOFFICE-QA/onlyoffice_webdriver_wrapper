# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_all_combo_box_values' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:page) { CurrentPagePageObject.new(webdriver) }

  after { webdriver.quit }

  before do
    webdriver.open(local_file('select_from_list_elements.html'))
  end

  it 'get_all_combo_box_values returns a list of options' do
    expect(webdriver.get_all_combo_box_values('//select')[2]).to eq('opel')
  end
end
