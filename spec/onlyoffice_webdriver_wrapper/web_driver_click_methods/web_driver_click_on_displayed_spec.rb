# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#click_on_displayed' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'element_appear_after_click.html')
  end

  after { webdriver.quit }

  it 'click_on_displayed raise exception if not a single element found' do
    expect { webdriver.click_on_displayed('//foo') }
      .to raise_error(NoMethodError, /undefined method/)
  end

  it 'click_on_displayed correct click on element' do
    webdriver.click_on_displayed('//button')
    expect(webdriver.get_element('//*[@id="newElement"]')).not_to be_nil
  end

  it 'click_on_displayed correct work if displayed second element' do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'element_appear_after_click_click_on_displayed.html')
    webdriver.click_on_displayed('//button')
    expect(webdriver.get_element('//*[@id="newElement"]')).not_to be_nil
  end
end
