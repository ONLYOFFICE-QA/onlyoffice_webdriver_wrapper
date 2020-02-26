# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::Dimensions do
  it 'Dimensions has correct to_s method' do
    expect(described_class.new(50, 100).to_s)
      .to eq('Dimensions(left: 50, top: 100)')
  end
end
