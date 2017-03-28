# Class for working with files
class FileHelper
  class << self
    def delete_directory(path)
      FileUtils.rm_rf(path) if Dir.exist?(path)
    end

    # Create file with content
    # @param file_path [String] path to created file
    # @param [String] content content of file
    # @return [String] path to created file
    def create_file_with_content(file_path: '/tmp/temp_file.ext', content: '')
      File.open(file_path, 'w') { |f| f.write(content) }
      file_path
    end
  end
end
