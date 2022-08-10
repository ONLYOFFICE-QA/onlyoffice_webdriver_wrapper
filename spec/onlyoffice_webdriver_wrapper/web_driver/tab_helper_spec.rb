# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#tab_helper' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  describe '#new_tab' do
    it 'new_tab increase tab count by one' do
      tab_count = webdriver.tab_count
      webdriver.new_tab
      expect(webdriver.tab_count).to eq(tab_count + 1)
    end
  end

  describe '#resize_tab' do
    before do
      webdriver.resize_tab(500, 500)
    end

    it 'resize_tab change width of tab' do
      expect(webdriver.driver.manage.window.size.width).to eq(500)
    end

    it 'resize_tab change height of tab' do
      expect(webdriver.driver.manage.window.size.height).to eq(500)
    end
  end

  describe '#choose_tab' do
    before do
      webdriver.open('https://ya.ru')
      webdriver.new_tab
      webdriver.choose_tab(2)
      webdriver.open('https://google.com')
      webdriver.choose_tab(1)
    end

    it 'correctly choose first tab' do
      expect(webdriver.get_title_of_current_tab).to include('Яндекс')
    end

    it 'correctly choose second tab' do
      webdriver.choose_tab(2)
      expect(webdriver.get_title_of_current_tab).to include('Google')
    end

    it 'raise error if no such tab present' do
      expect { webdriver.choose_tab(3, timeout: 1) }
        .to raise_error(RuntimeError, /choose_tab: Tab number = 3 not found/)
    end
  end

  describe '#swith_to_main_tab' do
    it 'switch_to_main_tab return to first tab' do
      webdriver.new_tab
      webdriver.choose_tab(2)
      webdriver.open('https://google.com')
      webdriver.switch_to_main_tab
      expect(webdriver.get_title_of_current_tab).not_to include('Google')
    end
  end

  describe '#close_tab' do
    it 'by closing tab tab count is one' do
      webdriver.new_tab
      webdriver.close_tab
      expect(webdriver.tab_count).to eq(1)
    end
  end

  describe '#close_popup_and_switch_to_main_tab' do
    before do
      webdriver.new_tab
      webdriver.choose_tab(2)
      webdriver.open('https://google.com')
      webdriver.close_popup_and_switch_to_main_tab
    end

    it 'close_popup_and_switch_to_main_tab return focus to main tab' do
      expect(webdriver.get_title_of_current_tab).not_to include('Google')
    end

    it 'close_popup_and_switch_to_main_tab make tab count equal 1' do
      expect(webdriver.tab_count).to eq(1)
    end
  end
end
