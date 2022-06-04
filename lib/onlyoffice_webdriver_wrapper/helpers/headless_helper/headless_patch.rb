# Monkey-patching class from `headless` gem
class Headless
  # Fix incorrect taking of screenshots
  # @param [String] file_path Path to store screenshot
  # @param [Hash] options Different options
  # @return [void]
  def take_screenshot(file_path, options={})
    using = options.fetch(:using, :imagemagick)
    case using
    when :imagemagick
      CliUtil.ensure_application_exists!('import', "imagemagick is not found on your system. Please install it using sudo apt-get install imagemagick")
      system "#{CliUtil.path_to('import')} -display :#{display} -window root #{file_path}"
    when :xwd
      CliUtil.ensure_application_exists!('xwd', "xwd is not found on your system. Please install it using sudo apt-get install X11-apps")
      system "#{CliUtil.path_to('xwd')} -display localhost:#{display} -silent -root -out #{file_path}"
    when :graphicsmagick, :gm
      CliUtil.ensure_application_exists!('gm', "graphicsmagick is not found on your system. Please install it.")
      system "#{CliUtil.path_to('gm')} import -display localhost:#{display} -window root #{file_path}"
    else
      raise Headless::Exception.new('Unknown :using option value')
    end
  end
end

# Until https://github.com/leonid-shevtsov/headless/pull/106
# is released in stable version
class VideoRecorder
  def stop_and_save(path)
    CliUtil.kill_process(@pid_file_path, :wait => true)
    if File.exist? @tmp_file_path
      begin
        FileUtils.mkdir_p(File.dirname(path))
        FileUtils.mv(@tmp_file_path, path)
      rescue Errno::EINVAL
        nil
      end
    end
  end
end

