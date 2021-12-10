# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Class for working with cursor coordinates
  class Dimensions
    attr_accessor :left, :top

    def initialize(left, top)
      @left = left
      @top = top
    end

    alias width left
    alias height top
    alias x left
    alias y top

    # @return [String] String representation of Dimensions
    def to_s
      "Dimensions(left: #{@left}, top: #{@top})"
    end
  end
end
