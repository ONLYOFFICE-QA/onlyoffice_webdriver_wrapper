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

  describe '#get_attributes_of_several_elements' do
    it 'get_attributes_of_several_elements if elements exists' do
      expect(webdriver.get_attributes_of_several_elements('//div', 'custom-attribute'))
        .to eq(%w[first second])
    end

    it 'get_attributes_of_several_elements if no elements' do
      expect(webdriver.get_attributes_of_several_elements('//div', 'no-attribute'))
        .to eq([nil, nil])
    end

    it 'get_attributes_of_several_elements if not-existin element' do
      expect(webdriver.get_attributes_of_several_elements('//no', 'no-attribute'))
        .to be_empty
    end
  end

  describe '#get_index_of_elements_with_attribute' do
    it 'get_index_of_elements_with_attribute for several objects' do
      expect(webdriver.get_index_of_elements_with_attribute('//span', 'custom-attribute', 'findable')).to eq(1)
    end

    it 'get_index_of_elements_with_attribute for several only_visible false' do
      expect(webdriver.get_index_of_elements_with_attribute('//span', 'custom-attribute', 'findable', false)).to eq(2)
    end

    it 'get_index_of_elements_with_attribute for non-existing object' do
      expect(webdriver.get_index_of_elements_with_attribute('//no', 'custom-attribute', 'findable')).to eq(0)
    end
  end

  after { webdriver.quit }
end
