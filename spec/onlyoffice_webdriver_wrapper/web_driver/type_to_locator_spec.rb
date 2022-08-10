# frozen_string_literal: true

require 'rspec'

describe OnlyofficeWebdriverWrapper::WebDriver, '#type_to_locator' do
  let(:webdriver) { described_class.new(:chrome) }
  let(:user) { 'user@example.com' }
  let(:user_xpath) { '//*[@id="login_field"]' }
  let(:password) { 'password' }
  let(:password_xpath) { '//*[@id="password"]' }

  before do
    webdriver.open('https://github.com/login')
  end

  after { webdriver.quit }

  describe 'Type to locator to github login page' do
    describe 'With default arguments' do
      before do
        webdriver.type_to_locator(user_xpath, user)
        webdriver.type_to_locator(password_xpath, password)
      end

      it 'Default type should enter correct user' do
        expect(webdriver.get_text(user_xpath)).not_to eq(user)
      end

      it 'Default type should enter incorrect password' do
        expect(webdriver.get_text(password_xpath)).not_to eq(password)
      end
    end

    describe 'With custom arguments' do
      before do
        webdriver.type_to_locator(user_xpath, user, true, true)
        webdriver.type_to_locator(password_xpath, password, true, true)
      end

      it 'Custom type should enter correct user' do
        expect(webdriver.get_text(user_xpath)).to eq(user)
      end

      it 'Custom type should enter incorrect password' do
        expect(webdriver.get_text(password_xpath)).to eq(password)
      end
    end
  end

  it 'type_to_locator combination with control get no input in locator' do
    webdriver.type_to_locator(user_xpath, 'test')
    webdriver.type_to_locator(user_xpath, [:control, 'a'])
    expect(webdriver.get_text(user_xpath)).to be_empty
  end
end
