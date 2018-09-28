# Change log

## master (unreleased)

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
