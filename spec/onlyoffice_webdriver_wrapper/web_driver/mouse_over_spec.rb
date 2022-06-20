# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#mouse_over' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'drag_and_drop can move one object into another' do
    element_to_hover = '//div'
    webdriver.open(local_file('mouse_over.html'))
    webdriver.mouse_over(element_to_hover)
    expect(webdriver.get_style_parameter('//body',
                                         'background'))
      .to eq('rgb(0, 0, 0)')
  end
end
