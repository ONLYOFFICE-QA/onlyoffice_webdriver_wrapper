# Change log

## master (unreleased)
* Remove `Webdriver#download_directory` after `Webdriver#quit`
* Support of `Webdriver#proxy`
* Add method `Webdriver#browser_metadata`

### New Features
* Update geckodriver from 0.18.0 to 0.20.1 

### Fixes
* Fix `Webdriver#alert_exists?` for `firefox`
* Do not crash on `Webdrvier#browser_logs` in `firefox`
