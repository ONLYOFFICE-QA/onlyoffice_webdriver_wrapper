# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Methods to record video
  module HeadlessVideoRecorder
    # @return [String] uniq file path to recorded file
    def recorded_video_file
      return @recorded_video_file if @recorded_video_file

      file_pattern = 'onlyoffice_webdriver_wrapper_video_file'
      temp_file = Tempfile.new([file_pattern, '.mp4'])
      @recorded_video_file = temp_file.path
      temp_file.unlink
      @recorded_video_file
    end

    # @return [nil] start capture of file
    def start_capture
      headless_instance.video.start_capture if record_video
    rescue Headless::Exception => e
      OnlyofficeLoggerHelper.log("Cannot start video capture: #{e}")
      @record_video = false
    end

    # @return [nil] stop catpure of file
    def stop_capture
      return unless record_video

      headless_instance.video.stop_and_save(recorded_video_file)
      OnlyofficeLoggerHelper.log("Video is saved to #{recorded_video_file}")
    end
  end
end
