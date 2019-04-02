# Change log

## master (unreleased)

## 0.0.2 (2018-11-07)

### New Features

* Update `geckodriver` from 0.20.1 to 0.23.0
* Update `selenium-webdriver` gem from 3.14.0 to 3.14.1
* Update `chromedriver` from 2.41 to 2.43
* Add `Dimensions#to_s` method

### Fixes

* Fix `WebDriver#switch_to_popup` cause page to stop loading
* Add `WebDriver#switch_to_popup` `after_switch_timeout` param to set timeout

### Refactor

* Remove unused method `WebDriver#type_text_by_symbol`

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
