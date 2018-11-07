module OnlyofficeWebdriverWrapper
  # Module for work with tabs
  module WebdriverTabHelper
    TIMEOUT_WAIT_ELEMENT = 15

    def new_tab
      execute_javascript('window.open()')
    end

    def maximize
      @driver.manage.window.maximize
      OnlyofficeLoggerHelper.log('Maximized current window')
    end

    def resize_tab(width, height)
      @driver.manage.window.resize_to(width, height)
      OnlyofficeLoggerHelper.log("Resize current window to #{width}x#{height}")
    end

    def switch_to_popup
      counter = 0
      while tab_count < 2 && counter < 30
        sleep 1
        counter += 1
      end
      webdriver_error('switch_to_popup: Popup window not found') if counter >= 30
      list_of_handlers = @driver.window_handles
      last_window_handler = list_of_handlers.last
      @driver.switch_to.window(last_window_handler)
      sleep 1 # Do not remove until problem with page loading stop resolved
    end

    # Get tab count
    # @return [Integer] count of tabs in opened session
    def tab_count
      tab_count = @driver.window_handles.length
      OnlyofficeLoggerHelper.log("tab_count: #{tab_count}")
      tab_count
    end

    def choose_tab(tab_number)
      counter = 0
      while tab_count < 2 && counter < TIMEOUT_WAIT_ELEMENT
        sleep 1
        counter += 1
      end
      webdriver_error("choose_tab: Tab number = #{tab_number} not found") if counter >= TIMEOUT_WAIT_ELEMENT
      @driver.switch_to.window(@driver.window_handles[tab_number - 1])
    end

    def switch_to_main_tab
      @driver.switch_to.window(@driver.window_handles.first)
    end

    def close_tab
      @driver.close
      sleep 1
      switch_to_main_tab
    end

    def close_window
      @driver.close
    end

    def close_popup_and_switch_to_main_tab
      switch_to_popup
      close_tab
      switch_to_main_tab
    end

    def get_title_of_current_tab
      @driver.title
    end
  end
end
