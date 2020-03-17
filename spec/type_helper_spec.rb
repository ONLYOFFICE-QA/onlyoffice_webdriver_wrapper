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

  describe 'type_to_locator' do
    it 'type_to_locator cannot clear blocked element' do
      expect do
        webdriver.type_to_locator('//input[@id="disabled"]',
                                  'text',
                                  true)
      end.to raise_error(Selenium::WebDriver::Error::ElementNotInteractableError)
    end

    it 'type_to_locator type_to_locator' do
      webdriver.type_to_locator('//input',
                                'foo',
                                true,
                                false,
                                false,
                                true)
      expect(webdriver.get_text('//input')).to eq('foo')
    end
  end

  describe 'type_to_input' do
    it 'clear element is correct' do
      webdriver.type_to_input('//input', 'foo')
      webdriver.type_to_input('//input', 'bar', true)
      expect(webdriver.get_text('//input')).to eq('bar')
    end

    it 'click on blocked element' do
      expect do
        webdriver.type_to_input('//input[@id="disabled"]',
                                'foo',
                                false,
                                true)
      end.to raise_error(Selenium::WebDriver::Error::ElementNotInteractableError)
    end
  end

  describe 'send_keys' do
    it 'send_keys default' do
      webdriver.send_keys('//input', 'foo')
      expect(webdriver.get_text('//input')).to eq('foo')
    end

    it 'send_keys not by action' do
      webdriver.send_keys('//input', 'foo', false)
      expect(webdriver.get_text('//input')).to eq('foo')
    end
  end

  describe 'send_keys_to_focused_elements' do
    it 'send_keys_to_focused_elements default' do
      webdriver.send_keys_to_focused_elements('foo')
      expect(webdriver.get_text('//input')).to eq('foo')
    end
  end

  describe 'press_key' do
    it 'press_key single button' do
      webdriver.press_key('a')
      expect(webdriver.get_text('//input')).to eq('a')
    end
  end

  describe 'key_down' do
    it 'key_down for control is correct' do
      webdriver.send_keys_to_focused_elements('foo')
      webdriver.key_down('//input', :control)
      webdriver.send_keys_to_focused_elements('a')
      expect(webdriver.get_text('//input')).to eq('foo')
    end
  end

  describe 'key_up' do
    it 'key_down for control is correct' do
      webdriver.send_keys_to_focused_elements('foo')
      webdriver.key_down('//input', :control)
      webdriver.key_up('//input', :control)
      webdriver.send_keys_to_focused_elements('a')
      expect(webdriver.get_text('//input')).to eq('fooa')
    end
  end
end
