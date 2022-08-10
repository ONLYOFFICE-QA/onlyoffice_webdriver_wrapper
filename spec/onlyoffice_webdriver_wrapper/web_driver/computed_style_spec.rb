# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#computed_style' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('pseudo_class_test.html'))
  end

  after { webdriver.quit }

  it 'WebdriverJsMethods#computed_style for none element' do
    expect(webdriver.computed_style('//*[@id="first_element"]',
                                    ':before',
                                    'content')).to eq('none')
  end

  it 'WebdriverJsMethods#computed_style for second element' do
    expect(webdriver.computed_style('//*[@id="second_element"]',
                                    ':before',
                                    'content')).to eq('with_pseudo_')
  end
end
