require 'rspec'

describe 'Webdriver Firefox' do
  it 'Check That firefox start correctly' do
    expect { OnlyofficeWebdriverWrapper::WebDriver.new(:firefox) }.not_to raise_error
  end
end
