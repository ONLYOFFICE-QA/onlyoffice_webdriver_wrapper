# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '#select_frame' do
  let(:webdriver) { described_class.new(:chrome) }

  after { webdriver.quit }

  it 'select_frame will not raise an error for non-existing frame' do
    expect { webdriver.select_frame }.to output.to_stdout
  end
end
