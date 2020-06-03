class Headless
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
