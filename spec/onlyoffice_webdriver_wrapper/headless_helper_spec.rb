# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::HeadlessHelper do
  let(:headless) { described_class.new }

  before do
    headless.start
  end

  it 'Can take screenshot to file' do
    file = Tempfile.new(['screenshot', '.png'])
    headless.take_screenshot(file.path)
    expect(File.size(file.path)).to be > 100
    file.unlink
  end
end
