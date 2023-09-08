# frozen_string_literal: true

require 'rspec'

# Test for checking this bug https://github.com/SeleniumHQ/selenium/issues/12659
describe OnlyofficeWebdriverWrapper::WebDriver, '#bug_12659' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open(local_file('style_helper.html'))
  end

  after { webdriver.quit }

  it 'by default "_" js variable is not defined' do
    expect { webdriver.execute_javascript('console.log(_)') }.to raise_error(/is not defined/)
  end

  it 'running get_style_parameter do not override js _ var' do
    webdriver.get_style_parameter('//div', 'display')
    expect { webdriver.execute_javascript('console.log(_)') }.to raise_error(/is not defined/)
  end
end
