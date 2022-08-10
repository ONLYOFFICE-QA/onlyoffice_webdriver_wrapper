# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#element_size_by_js' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  describe 'For whole body' do
    let(:dimensions) { webdriver.element_size_by_js('//div') }

    before do
      webdriver.open(local_file('web_driver_element_size_by_js_spec.html'))
    end

    it 'element_size_by_js for full screen element height more than half screen' do
      expect(dimensions.height).to be > (webdriver.browser_size.y / 2)
    end

    it 'element_size_by_js for full screen element width more than half screen' do
      expect(dimensions.width).to be > (webdriver.browser_size.x / 2)
    end
  end

  describe 'For some element on page' do
    let(:element_size) { webdriver.element_size_by_js('//*[@id="first_element"]') }

    before do
      webdriver.open(local_file('pseudo_class_test.html'))
    end

    it 'element_size_by_js x for element is more than zero' do
      expect(element_size.x).to be > 0
    end

    it 'element_size_by_js y for element is more than zero' do
      expect(element_size.y).to be > 0
    end
  end
end
