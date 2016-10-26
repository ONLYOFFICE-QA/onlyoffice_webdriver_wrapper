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
end