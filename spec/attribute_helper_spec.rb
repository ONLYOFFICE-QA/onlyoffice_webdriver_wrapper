# frozen_string_literal: true

require 'rspec'

describe 'OnlyofficeWebdriverWrapper::WebDriver#WebdriverAttributesHelper' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                      'attribute_helper.html')
  end

  describe '#attribute_exist?' do
    it 'attribute_exist? true' do
      expect(webdriver).to be_attribute_exist('//div', 'hidden')
    end

    it 'attribute_exist? false' do
      expect(webdriver).not_to be_attribute_exist('//div', 'pidden')
    end

    it 'attribute_exist? for non-existing element' do
      expect(webdriver).not_to be_attribute_exist('//div1', 'pidden')
    end
  end

  describe '#get_attribute' do
    it 'get_attribute for existing attribute' do
      expect(webdriver.get_attribute('//div', 'hidden')).to eq('true')
    end

    it 'get_attribute for non-existing element' do
      expect { webdriver.get_attribute('//div1', 'hidden') }
        .to raise_error(RuntimeError, /failed because element not found/)
    end
  end

  after { webdriver.quit }
end
