# frozen_string_literal: true

require 'spec_helper'

describe OnlyofficeWebdriverWrapper::Dimensions do
  it 'Dimensions has correct to_s method' do
    expect(described_class.new(50, 100).to_s)
      .to eq('Dimensions(left: 50, top: 100)')
  end

  it 'Dimensions can return center coordinates' do
    expect(described_class.new(200, 100).center)
      .to eq(described_class.new(100, 50))
  end

  it 'Dimensions can be compared with any object' do
    expect(described_class.new(50, 100)).not_to eq(Object.new)
  end
end
