# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#video_recorder' do
  let(:webdriver) { described_class.new(:chrome) }

  before do
    webdriver.open("file://#{Dir.pwd}/spec/html_examples/"\
                   'get_element_count.html')
  end

  it 'Can capture video file' do
    webdriver.quit
    expect(File.size(webdriver.headless.recorded_video_file)).to be > 10_000
  end
end
