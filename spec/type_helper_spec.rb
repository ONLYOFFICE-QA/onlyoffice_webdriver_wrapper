# frozen_string_literal: true

require 'rspec'

describe '#type_helper' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'type_helper.html')
  end

  after { webdriver.quit }

  describe 'type_text' do
    it 'type_text set correct value' do
      webdriver.type_text('//input', 'foo')
      expect(webdriver.get_text('//input')).to eq('foo')
    end

    it 'type_text twice without clear add text to input' do
      webdriver.type_text('//input', 'foo')
      webdriver.type_text('//input', 'bar')
      expect(webdriver.get_text('//input')).to eq('foobar')
    end

    it 'type_text with clear only left second input' do
      webdriver.type_text('//input', 'foo')
      webdriver.type_text('//input', 'bar', true)
      expect(webdriver.get_text('//input')).to eq('bar')
    end
  end

  describe 'type_text_and_select_it' do
    it 'type_text_and_select_it text will replaced in next type' do
      text_element = webdriver.get_element('//input')
      webdriver.type_text_and_select_it(text_element, 'foo')
      webdriver.type_text('//input', 'bar')
      expect(webdriver.get_text('//input')).to eq('bar')
    end
  end
end
