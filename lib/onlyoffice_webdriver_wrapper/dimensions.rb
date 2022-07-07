# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Class for working with cursor coordinates
  class Dimensions
    attr_accessor :left, :top

    def initialize(left, top)
      @left = left
      @top = top
    end

    # Compare two dimensions object
    # @param [Object] other object
    # @return [Boolean] result of comparison
    def ==(other)
      return false unless other.respond_to?(:left) && other.respond_to?(:top)

      @left == other&.left && @top == other&.top
    end

    alias width left
    alias height top
    alias x left
    alias y top

    # @return [String] String representation of Dimensions
    def to_s
      "Dimensions(left: #{@left}, top: #{@top})"
    end

    # @return [Dimensions] Center point of current dimension
    def center
      Dimensions.new(@left / 2, @top / 2)
    end
  end
end
