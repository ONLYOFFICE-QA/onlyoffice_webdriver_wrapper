# Some additional methods for webdriver
module WebdriverHelper
  # Round coordinates for clicks
  # TODO: remove it after https://github.com/SeleniumHQ/selenium/pull/1987 go to release
  # @param x_coordinate [Float] any number
  # @param y_coordinate [Float] any number
  # @return [Array, Integer, Integer]
  def round_coordinates(x_coordinate, y_coordinate)
    x_coordinate = x_coordinate.round unless x_coordinate.nil?
    y_coordinate = y_coordinate.round unless y_coordinate.nil?
    [x_coordinate, y_coordinate]
  end

  def kill_all
    LoggerHelper.print_to_log('killall -9 chromedriver 2>&1')
    `killall -9 chromedriver 2>&1`
  end

  def system_screenshot(file_name)
    `import -window root #{file_name}`
  end
end
