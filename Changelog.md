# Change log

## master (unreleased)

### Features

* Do not remove `@download_directory` if it's not in `/tmp/`
* `Webdriver#execute_javascript` new param to sleep after execute

### Fixes

* Fix `Encoding::UndefinedConversionError` for `Webdriver#download`
* Fix incorrect file download location
* Do not try to start selenium once more

### Removal

* Remove unused `Webdriver.web_console_error`
* Remove unused `Webdriver#set_text_to_iframe`
* Remove unused `Webdriver#get_style_attributes_of_several_elements`
* Remove `xrandr` exception handling

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
