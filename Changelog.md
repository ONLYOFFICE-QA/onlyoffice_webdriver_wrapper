# Change log

## master (unreleased)

### New Features

* Add `Dimensions#to_s` method
* Add `w3c: false` to access logs on latest chromedriver
* Update `chromedriver` to 75.0.3770.8
* Update `selenium-webdriver` gem from `3.141.0` to `3.142.3`
  and drop support of ruby older than 2.3
* Update `geckodriver` from 0.23.0 to 0.24.0

### Fixes

* Add `WebDriver#switch_to_popup` `after_switch_timeout` param to set timeout
* Fix `WebDriver#add_class_by_jquery`
* Fix `WebDriver#remove_class_by_jquery`
* Fix deprecation of `driver_path`
* Fix quitting from already quit browser session

### Refactor

* Remove unused method `WebDriver#type_text_by_symbol`
* Remove non-actual exception handling in `WebDriver#drag_and_drop`
* Simplify AbcSize of `WebDriver#drag_and_drop`

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
