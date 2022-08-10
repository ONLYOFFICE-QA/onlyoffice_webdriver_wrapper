# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::WebDriver, '.initialize' do
  it 'raise exception if trying to start unknown browser' do
    expect { described_class.new(:foo) }
      .to raise_error(RuntimeError, 'Unknown Browser: foo')
  end
end
