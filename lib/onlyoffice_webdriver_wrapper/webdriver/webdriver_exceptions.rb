# frozen_string_literal: true

module OnlyofficeWebdriverWrapper
  # Exception class if system is not supported
  class WebdriverSystemNotSupported < StandardError; end
  # If entry needed to be selected not found in select
  class SelectEntryNotFound < StandardError; end
end
