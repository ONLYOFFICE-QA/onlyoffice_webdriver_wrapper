require 'spec_helper'

describe 'Webdriver Firefox' do
  let(:webdriver) { OnlyofficeWebdriverWrapper::WebDriver.new(:firefox) }

  it 'Check That firefox start correctly' do
    expect { webdriver }.not_to raise_error
  end

  after do
    webdriver.quit
  end
end
