# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Module for work with tabs
  module WebdriverTabHelper
    # @return [Integer] Default timeout for waiting for element
    TIMEOUT_WAIT_ELEMENT = 15

    # Create new tab
    # @return [void]
    def new_tab
      execute_javascript('window.open()')
    end

    # Resize current tab to specific size
    # @param [Integer] width to set
    # @param [Integer] height to set
    # @return [void]
    def resize_tab(width, height)
      @driver.manage.window.resize_to(width, height)
      OnlyofficeLoggerHelper.log("Resize current window to #{width}x#{height}")
    end

    # Switch to popup window
    # @param popup_appear_timeout [Integer] how much time to wait for popup window
    # @param after_switch_timeout [Integer] wait after switch to window
    # non-zero to workaround bug with page load hanging up after switch
    # @return [void]
    def switch_to_popup(after_switch_timeout: 3, popup_appear_timeout: 30)
      counter = 0
      while tab_count < 2 && counter < popup_appear_timeout
        sleep 1
        counter += 1
      end
      webdriver_error('switch_to_popup: Popup window not found') if counter >= popup_appear_timeout
      list_of_handlers = @driver.window_handles
      last_window_handler = list_of_handlers.last
      @driver.switch_to.window(last_window_handler)
      sleep(after_switch_timeout) # Do not remove until problem with page loading stop resolved
    end

    # Get tab count
    # @return [Integer] count of tabs in opened session
    def tab_count
      tab_count = @driver.window_handles.length
      OnlyofficeLoggerHelper.log("tab_count: #{tab_count}")
      tab_count
    end

    # Choose tab by it's number
    # @param [Integer] tab_number to choose
    # @param [Integer] timeout how much for this tab
    # @raise [RuntimeError] error if tab not found
    # @return [void]
    def choose_tab(tab_number, timeout: TIMEOUT_WAIT_ELEMENT)
      counter = 0
      while tab_count < tab_number && counter < timeout
        sleep 1
        counter += 1
      end
      webdriver_error("choose_tab: Tab number = #{tab_number} not found") if counter >= timeout
      @driver.switch_to.window(@driver.window_handles[tab_number - 1])
    end

    # Switch to first tab of chrome
    # @return [void]
    def switch_to_main_tab
      @driver.switch_to.window(@driver.window_handles.first)
    end

    # Close current active tab and switch to first one
    # @return [void]
    def close_tab
      @driver.close
      sleep 1
      switch_to_main_tab
    end

    # Wait for popup window, close it and return to first tab
    # @return [void]
    def close_popup_and_switch_to_main_tab
      switch_to_popup
      close_tab
      switch_to_main_tab
    end

    # @return [String] title of current tab
    def title_of_current_tab
      @driver.title
    end

    alias get_title_of_current_tab title_of_current_tab

    extend Gem::Deprecate
    deprecate :get_title_of_current_tab, 'title_of_current_tab', 2069, 1
  end
end
