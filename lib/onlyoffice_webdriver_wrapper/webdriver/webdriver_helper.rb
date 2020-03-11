# frozen_string_literal: true

require 'open-uri'
require 'tempfile'

module OnlyofficeWebdriverWrapper
  # Some additional methods for webdriver
  module WebdriverHelper
    def system_screenshot(file_name)
      `import -window root #{file_name}`
    end

    # Download temp file and return it location
    # @param file [String] url
    # @return [String] path to file
    def download(file_url)
      data = Kernel.open(file_url, &:read)
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
        OnlyofficeLoggerHelper.log("Download directory #{@download_directory} is not at /tmp. "\
                                   'It will be not deleted')
      end
    end
  end
end
