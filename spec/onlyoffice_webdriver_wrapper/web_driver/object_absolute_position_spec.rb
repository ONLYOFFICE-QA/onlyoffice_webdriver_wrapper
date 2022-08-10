# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#object_absolute_position' do
  let(:webdriver) { described_class.new(:chrome) }

  after do
    webdriver.quit
  end

  describe 'For page body' do
    let(:position) { webdriver.object_absolute_position('//body') }

    it 'object_absolute_position of body height > 0' do
      expect(position.height).to be > 0
    end

    it 'object_absolute_position of body width > 0' do
      expect(position.width).to be > 0
    end
  end

  describe 'For some object' do
    let(:position) { webdriver.object_absolute_position('//*[@id="first_element"]') }

    before do
      webdriver.open(local_file('pseudo_class_test.html'))
    end

    it 'object_absolute_position x more than zero' do
      expect(position.x).to be > 0
    end

    it 'object_absolute_position y more than zero' do
      expect(position.y).to be > 0
    end
  end
end
