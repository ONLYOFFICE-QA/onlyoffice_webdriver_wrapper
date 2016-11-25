module OnlyofficeWebdriverWrapper
  # Some additional methods for webdriver
  module WebdriverHelper
    def system_screenshot(file_name)
      `import -window root #{file_name}`
    end
  end
end
