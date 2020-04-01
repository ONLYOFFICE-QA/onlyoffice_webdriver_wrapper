# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#get_page_source' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'get_page_source is not empty' do
    expect(webdriver.get_page_source).not_to be_empty
  end

  it 'get_page_source contain html tags' do
    expect(webdriver.get_page_source).to include('<head>')
  end
end
