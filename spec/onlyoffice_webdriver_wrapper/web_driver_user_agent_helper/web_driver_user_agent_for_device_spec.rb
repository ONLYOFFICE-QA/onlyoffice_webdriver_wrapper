# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#user_agent_for_device' do
  webdriver = nil
  after { webdriver.quit }

  it 'user_agent_for_device is nil by default' do
    webdriver = described_class.new(:chrome)
    expect(webdriver.user_agent_for_device).to be_nil
  end

  it 'user_agent_for_device is not empty for android_phone' do
    webdriver = described_class.new(:chrome, device: :android_phone)
    expect(webdriver.user_agent_for_device).not_to be_empty
  end

  it 'user_agent_for_device is not empty for iphone' do
    webdriver = described_class.new(:chrome, device: :iphone)
    expect(webdriver.user_agent_for_device).not_to be_empty
  end

  it 'user_agent_for_device is not empty for ipad_air_2_safari' do
    webdriver = described_class.new(:chrome, device: :ipad_air_2_safari)
    expect(webdriver.user_agent_for_device).not_to be_empty
  end

  it 'user_agent_for_device is not empty for nexus_10_chrome' do
    webdriver = described_class.new(:chrome, device: :nexus_10_chrome)
    expect(webdriver.user_agent_for_device).not_to be_empty
  end

  it 'user_agent_for_device is not empty for random device' do
    fake_device = :ipad_air_fake
    expect { described_class.new(:chrome, device: fake_device) }
      .to raise_error(RuntimeError, /Unknown user device for starting browser: #{fake_device}/)
  end
end
