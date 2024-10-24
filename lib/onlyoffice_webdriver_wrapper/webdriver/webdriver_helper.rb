# frozen_string_literal: true

require 'open-uri'
require 'tempfile'

module OnlyofficeWebdriverWrapper
  # Some additional methods for webdriver
  module WebdriverHelper
    # Make screenshot by system methods
    # Works only on Linux
    # @param [String] file_name to export screenshot
    # @return [String] result of screenshot command execution
    def system_screenshot(file_name)
      `import -window root #{file_name}`
    end

    # Download temp file and return it location
    # @param file_url [String] url
    # @return [String] path to file
    def download(file_url)
      data = URI.parse(file_url).open.read
      file = Tempfile.new('onlyoffice-downloaded-file')
      file.write(data.force_encoding('UTF-8'))
      file.close
      file.path
    end

    # Perform safe cleanup of download folder
    # @return [Nothing]
    def cleanup_download_folder
      return unless Dir.exist?(@download_directory)

      if @download_directory.start_with?(Dir.tmpdir)
        FileUtils.remove_dir(@download_directory)
      else
        OnlyofficeLoggerHelper.log("Download directory #{@download_directory} is not at tmp dir. " \
                                   'It will be not deleted')
      end
    end
  end
end
