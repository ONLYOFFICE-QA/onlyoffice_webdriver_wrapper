module OnlyofficeWebdriverWrapper
  # Class for helping with system processes
  module ProcessHelper
    # @param process [String] process to kill
    # @return [Nothing] kill specified process
    def kill_process(process)
      OnlyofficeLoggerHelper.log("killall -9 #{process} 2>&1")
      `killall -9 #{process} 2>&1`
    end

    # @return [Nothing] kill all webdriver-related process-es
    def kill_all
      kill_process('chromedriver')
      kill_process('geckodriver')
      kill_process('Xvfb')
      kill_process('chrome')
    end

    def show_processes
      proceses = `ps -ef`
      OnlyofficeLoggerHelper.log("There is processes on server: #{proceses}")
    end

    def show_ports
      ports_usage = `netstat -tulpn`
      OnlyofficeLoggerHelper.log("There is ports usage on server: #{ports_usage}")
    end
  end
end
