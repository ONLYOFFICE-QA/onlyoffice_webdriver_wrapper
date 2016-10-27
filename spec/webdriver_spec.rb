require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver do
  describe 'Default tests' do
    let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

    it 'Check for popup open' do
      webdriver.new_tab
      expect(webdriver.tab_count).to eq(2)
    end

    it 'choose_tab' do
      expect { webdriver.choose_tab(2) }.to raise_error(RuntimeError, /choose_tab: Tab number = 2 not found/)
    end

    it 'Check for browser size' do
      expect(webdriver.browser_size.x).to eq(webdriver.headless.resolution_x)
      expect(webdriver.browser_size.y).to eq(webdriver.headless.resolution_y)
    end

    it 'element_size_by_js' do
      dimensions = webdriver.element_size_by_js('//body')
      expect(dimensions.height).to be > 900
      expect(dimensions.width).to be > 1600
    end

    it 'object_absolute_position' do
      position = webdriver.object_absolute_position('//body')
      expect(position.height).to be > 0
      expect(position.width).to be > 0
    end

    it 'type_to_input raise error for nil' do
      expect { webdriver.type_to_input('//*[@id="unknwon-id"', 'test') }.to raise_error(Selenium::WebDriver::Error::NoSuchElementError, /element not found/)
    end

    describe 'right_click_on_locator_coordinates' do
      it 'right_click_on_locator_coordinates with empty coordinates' do
        webdriver.right_click_on_locator_coordinates('//body')
      end

      it 'right_click_on_locator_coordinates with nil coordinates' do
        webdriver.right_click_on_locator_coordinates('//body', nil, nil)
      end
    end

    describe 'get_url' do
      it 'get url in frame return url of frame, not mail url' do
        webdriver.open('http://www.google.com')
        webdriver.execute_javascript("var ifr = document.createElement('iframe');ifr.src = 'https://www.example.com/';document.body.appendChild(ifr)")
        webdriver.select_frame
        expect(webdriver.get_url).to eq('https://www.example.com/')
      end
    end

    describe 'get_host_name' do
      it 'get url in frame return host name of frame, not mail url' do
        webdriver.open('http://www.google.com')
        webdriver.execute_javascript("var ifr = document.createElement('iframe');ifr.src = 'https://www.example.com/';document.body.appendChild(ifr)")
        webdriver.select_frame
        expect(webdriver.get_host_name).to eq('https://www.example.com')
      end
    end
  end

  describe 'User agent' do
    describe 'Custom user agent' do
      let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome, device: :android_phone) }

      it 'set_custom_device_useragent' do
        expect(webdriver.current_user_agent).to eq(OnlyofficeWebdriverWrapper::WebDriver::USERAGENT_ANDROID_PHONE)
      end
    end

    describe 'Default user agent' do
      let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:chrome) }

      it 'default device name' do
        expect(webdriver.current_user_agent).not_to eq(OnlyofficeWebdriverWrapper::WebDriver::USERAGENT_ANDROID_PHONE)
      end
    end
  end

  after { webdriver.quit }
end
