# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#click' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('element_appear_after_click.html'))
  end

  after { webdriver.quit }

  it 'click on element is correct' do
    element = webdriver.get_element('//button')
    webdriver.click(element)
    expect(webdriver.get_element('//*[@id="newElement"]')).not_to be_nil
  end
end
