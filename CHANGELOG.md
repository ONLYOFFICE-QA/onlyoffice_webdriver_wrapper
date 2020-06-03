# Change log

## master (unreleased)

### Fixes

* Fix taking screenshot inside headless

### Changes

* Freeze specific version of `headless` gem

## 0.3.0 (2020-05-22)

### New Features

* Update `chromedriver` to `83.0.4103.39` 

## 0.2.0 (2020-05-18)

### Features

* Do not remove `@download_directory` if it's not in `/tmp/`
* `Webdriver#execute_javascript` new param to sleep after execute
* Add workaround for Webdriver bug with chrome typing with :control
* Update `chromedriver` to `81.0.4044.69`
* New method `Webdriver.clean_up` for stopping hang-up browsers
* Support of `rubocop-performance`
* Add rake task to release gem on github and rubygems

### Fixes

* Fix `Encoding::UndefinedConversionError` for `Webdriver#download`
* Fix incorrect file download location
* Do not try to start selenium once more
* Fix correct behavior for `Webdriver#get_element_count` with `only_visible: true`
* Fix `WebDriver#type_to_locator` for integer values

### Changes

* Minor refactor in gemfile
* Actualize rubocop todo to 0.83.0

### Removal

* Remove unused `Webdriver.web_console_error`
* Remove unused `Webdriver#set_text_to_iframe`
* Remove unused `Webdriver#get_style_attributes_of_several_elements`
* Remove `xrandr` exception handling
* Remove support of `ip_of_remote_server`
* Remove unused `Webdriver#get_attribute_from_displayed_element`
* Remove unused `Webdriver#maximize`
* Remove unused `Webdriver#close_window`
* Remove unused `Webdriver#get_element_number_by_text`
* Remove unused `Webdriver#click_on_locator_by_action`
* Remove unused `Webdriver#select_text_from_page`
* Remove unused `Webdriver#move_to_one_of_several_displayed_element`
* Remove unused `Webdriver#click_on_one_of_several_by_parameter_and_text`
* Remove unused `Webdriver#select_from_list`
* Remove unused `Webdriver#context_click`
* Remove unused `Webdriver#click_on_one_of_several_with_display_by_text`
* Remove unused `Webdriver#right_click_on_one_of_several_by_text`
* Remove unused `Webdriver#click_on_one_of_several_with_display_by_number`
* Remove unused `Webdriver#get_elements_from_array_before_some`
* Remove unused `Webdriver#get_elements_from_array_after_some`

## 0.1.2 (2020-02-18)

### New Features

* Add Rakefile and tasks for releasing gem
* Simplify travis config, remove non-actual code
* Add travis task for markdown and fix issues in Changelog.md
* Change screenshot S3 bucket location
* Rename and redone `jquery_selector_by_xpath` to `dom_element_by_xpath`

### Removal

* Remove `Webdriver#get_element_by_parameter`

## 0.1.1 (2019-12-25)

### New Features

* Replace all `visible?` usage to `present?`
* Add `Webdriver#computed_style` to get computed style of element via js
* Update `chromedriver` to 79.0.3945.36

## 0.1.0 (2019-10-18)

### New Features

* Add `Dimensions#to_s` method
* Add `w3c: false` to access logs on latest chromedriver
* Update `chromedriver` to 77.0.3865.40
* Update `selenium-webdriver` gem from `3.141.0` to `3.142.3`
  and drop support of ruby older than 2.3
* Update `geckodriver` from 0.23.0 to 0.24.0

### Fixes

* Add `WebDriver#switch_to_popup` `after_switch_timeout` param to set timeout
* Fix `WebDriver#add_class_by_jquery`
* Fix `WebDriver#remove_class_by_jquery`
* Fix deprecation of `driver_path`
* Fix quitting from already quit browser session
* Fix downloading multiple files in Chrome

### Refactor

* Remove unused method `WebDriver#type_text_by_symbol`
* Remove non-actual exception handling in `WebDriver#drag_and_drop`
* Simplify AbcSize of `WebDriver#drag_and_drop`
* Remove overwriting `START_TIMEOUT` and `STOP_TIMEOUT`

## 0.0.2 (2018-11-07)

### New Features

* Update `geckodriver` from 0.20.1 to 0.23.0
* Update `selenium-webdriver` gem from 3.14.0 to 3.14.1
* Update `chromedriver` from 2.41 to 2.43

### Fixes

* Fix `WebDriver#switch_to_popup` cause page to stop loading

## 0.0.1 (2018-09-28)

### New Features

* Update geckodriver from 0.18.0 to 0.20.1
* Add `Webdriver#download` for downloading files by link
* Support of `Webdriver#proxy`
* Add method `Webdriver#browser_metadata`

### Fixes

* Fix `Webdriver#alert_exists?` for `firefox`
* Do not crash on `Webdrvier#browser_logs` in `firefox`
* Fix crashes on `@driver.action.move_to` non-integer coordinates
* Add `webdriver_error` handling to `one_of_several_elements_displayed?`
* Remove `Webdriver#download_directory` after `Webdriver#quit`
