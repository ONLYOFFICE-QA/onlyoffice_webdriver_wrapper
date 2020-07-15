# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#set_style_show_by_xpath' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'style_helper.html')
  end

  after { webdriver.quit }

  it 'set_style_show_by_xpath by default show object' do
    webdriver.set_style_show_by_xpath('//span')
    expect(webdriver.get_style_parameter('//span', 'display')).to eq('block')
  end

  describe 'set_style_show_by_xpath with move_to_center' do
    before do
      webdriver.set_style_show_by_xpath('//span', true)
    end

    it 'object is shown' do
      expect(webdriver.get_style_parameter('//span', 'display')).to eq('block')
    end

    it 'object is moved by x' do
      expect(webdriver.get_style_parameter('//span', 'left')).to eq('410px')
    end

    it 'object is moved by y' do
      expect(webdriver.get_style_parameter('//span', 'top')).to eq('260px')
    end
  end
end
