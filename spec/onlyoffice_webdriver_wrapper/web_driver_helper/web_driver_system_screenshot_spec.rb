# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#system_screenshot' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'system_screenshot results file with some size' do
    path = Tempfile.new(%w[onlyoffice_webdriver_wrapper_spec .png]).path
    webdriver.system_screenshot(path)
    expect(File.size(path)).to be > 100
  end
end
