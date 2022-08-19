# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#page_source' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'page_source is not empty' do
    expect(webdriver.page_source).not_to be_empty
  end

  it 'page_source contain html tags' do
    expect(webdriver.page_source).to include('<head>')
  end
end
