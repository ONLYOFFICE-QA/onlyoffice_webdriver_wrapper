# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#move_to_element_by_locator' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'move_to_element_by_locator simulates mouse over element' do
    element_to_hover = '//div'
    webdriver.open(local_file('mouse_over.html'))
    webdriver.move_to_element_by_locator(element_to_hover)
    expect(webdriver.get_style_parameter('//body',
                                         'background'))
      .to eq('rgb(0, 0, 0)')
  end
end
