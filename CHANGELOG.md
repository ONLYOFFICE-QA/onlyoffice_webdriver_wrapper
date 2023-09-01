# Change log

## master (unreleased)

### New Features

* Add chromedriver `115.0.5790.102`
* Add chromedriver `116.0.5845.96`

### Fixes

* Fix memory leak for unsupported browser
* Fix minor headless leak in spec

### Changes

* Simplify taking screenshot code
* Increase test coverage by adding several tests
* Calculate code coverage only for latest ruby
* Remove chromedriver `112.0.5615.49`
* Change links for downloading new versions of chromedriver
* Remove chromedriver `113.0.5672.63`

## 1.18.0 (2023-06-02)

### New Features

* Add chromedriver `113.0.5672.63`
* Add chromedriver `114.0.5735.90`

### Changes

* Remove chromedriver `110.0.5481.77`
* Use current stable v3 of `codecov-action`
* Extract all linting tasks to separate workflow
* Increase code coverage
* Drop `ruby-2.7` support, since it's EOLed
* Remove chromedriver `111.0.5563.64`

## 1.17.0 (2023-04-13)

### New Features

* Add chromedriver `112.0.5615.49`

### Changes

* Remove chromedriver `109.0.5414.74`

## 1.16.0 (2023-03-10)

### New Features

* Add chromedriver `110.0.5481.77`
* Add chromedriver `111.0.5563.64`

### Changes

* Remove chromedriver `107.0.5304.62`
* Remove chromedriver `108.0.5359.71`

## 1.15.0 (2023-02-01)

### Changes

* Add support for `selenium-webdriver-4.8.0`
* Remove browser proxy support, it's not used for a long time
* Remove usage of browser capabilities.
  They will be deprecated in `selenium-webdriver` in the future

## 1.14.0 (2023-01-18)

### New Features

* Add chromedriver `109.0.5414.74`

### Changes

* Remove chromedriver `106.0.5249.61`

## 1.13.0 (2022-12-02)

### New Features

* Add chromedriver `107.0.5304.62`
* Add chromedriver `108.0.5359.71`

### Changes

* Remove chromedriver `104.0.5112.29`
* Remove chromedriver `105.0.5195.52`

## 1.12.0 (2022-10-10)

### New Features

* Add chromedriver `106.0.5249.61`

### Changes

* Remove chromedriver `103.0.5060.53`

## 1.11.0 (2022-08-31)

### New Features

* Ignore `.rake_tasks~` autocomplete file
* Add chromedriver `105.0.5195.52`
* Update `geckodriver` from `v0.30.0` to `v0.31.0`

### Changes

* Remove old comments from `RubyMine` code inspection
* Remove `WebDriver#wait_element` since it's not raise any error if wait failed.
  Use `WebDriver#wait_until_element_visible` instead
* Increase test coverage
* Remove calls to methods deprecated in `v1.10.0`
* Simplify `WebDriver#open_dropdown_selector` for firefox and add test for it
* Remove Chromedriver `102.0.5005.61`

## 1.10.1 (2022-08-10)

### Fixes

* Fix `WebDriver#scroll_list_by_pixels` failure

## 1.10.0 (2022-08-10)

### Changes

* Deprecate `WebDriver#get_title_of_current_tab`, `WebDriver#get_page_source`,
  `WebDriver#get_url` and replace them with another method name
* Fix several `rubocop` offenses

## 1.9.0 (2022-08-01)

### New Features

* Add chromedriver `104.0.5112.29`

### Changes

* Increase test coverage
* `WebDriver#select_from_list_elements` raise an exception if entry not found
* Remove unused `WebDriver#scroll_list_to_element` method
* `WebDriver#get_element_by_display` raise more detailed exception
* Remove Chromedriver `101.0.4951.15`

## 1.8.1 (2022-07-08)

### Fixes

* Fix `WebDriver#double_click_on_locator_coordinates` for
  new `ActionBuilder#move_to` coordinates system

### Changes

* Better documentation for several methods

## 1.8.0 (2022-07-07)

### New Features

* Add `Dimesnions#center` method

### Fixes

* Fix documentation for `WebDriver#get_element_index`
* Fix comparison of `Dimensions`

## 1.7.0 (2022-06-24)

### New Features

* Add Chromedriver `103.0.5060.53`

### Fixes

* Fix forgotten `quit` command in some specs

### Changes

* Add support of `ActionBuilder#move_to` with shift from center.
  It was introduced in `selenium-webdriver` v4.3.0
* Drop `ruby-2.6` support, since it's EOL'ed
* Patch `Headless` gem to be compatible with `ruby-3.2`
* Remove `w3school.com` usage from specs
* Add timeout options to `WebDriver#switch_to_popup` method
* Add `spec` method to get path of local file
* Remove unused `WebDriver#move_to_element` method
* Increase test coverage
* Remove Chromedriver `100.0.4896.60`

## 1.6.0 (2022-05-25)

### New Features

* Add Chromedriver `102.0.5005.61`

### Changes

* Remove Chromedriver `98.0.4758.102`

## 1.5.0 (2022-04-27)

### New Features

* Add Chromedriver `101.0.4951.15`

### Changes

* Fix `rubocop-1.28.1` code issues
* Remove Chromedriver `97.0.4692.71`
* Increase code coverage for `WebDriver#type_to_locator_by_javascript`

## 1.4.0 (2022-03-30)

### New Features

* Add `rake` task to update chromedriver exe
* Add Chromedriver `100.0.4896.60`

### Changes

* Increase test coverage
* Change expedition in `WebDriver#user_agent_for_device` for better error handling
* Remove Chromedriver `96.0.4664.35`

## 1.3.0 (2022-02-25)

### New Features

* Update `geckodriver` from `0.28.0` to `v0.30.0`
* Add Chromedriver `98.0.4758.102`

### Fixes

* `WebDriver#wait_until` will show `message` in error

### Changes

* Check `dependabot` at 8:00 Moscow time daily
* Remove Chromedriver `94.0.4606.41`

## 1.2.0 (2022-02-02)

### New Features

* Add Chromedriver `97.0.4692.71`
* Add `yamllint` in CI
* Add `CodeQL` in CI

### Changes

* Remove Chromedriver `92.0.4515.43`
* Remove `codeclimate` config, we don't use it any more

## 1.1.0 (2022-01-25)

### New Feature

* Handle JS Alerts in `wait_until` method

### Changes

* Drop support of `ruby-2.5`, since `selenium-webdriver` v4 do not support it

## 1.0.0 (2022-01-21)

### New Features

* Add `ruby-3.0` to CI
* Add `ruby-3.1` to CI

### Fix

* Fix deprecated url in firefox spec

### Changes

* Require `webdriver` v4
* Require `watir` v7
* `Selenium::WebDriver::Error::ElementNotVisibleError` replaced with
  `Selenium::WebDriver::Error::ElementNotInteractableError`
* `Selenium::WebDriver::Error::ElementNotInteractableError` replaced with
  `Selenium::WebDriver::Error::InvalidElementStateError`
* `TimeoutError` replaced with `Timeout::Error`
* Remove `ruby-2.5` from CI since it's EOLed

## 0.22.1 (2021-12-17)

### Fixes

* Fix incorrect `chromedriver` for Mac

## 0.22.0 (2021-12-13)

## New Features

* Add `timeout` option to `WebDriver#choose_tab`
* Add missing documentation
* Add check that 100% of code documented

## Fixes

* Fixe several typos in different parts of project
* Minor issues with HTML and documentation

## Changes

* Speedup `WebDriver#open` by checking if url is alive before opening it

## 0.21.0 (2021-12-10)

### Changes

* Upload screenshot with correct `content-type`

## 0.20.0 (2021-12-02)

### Fixes

* Fix `WebDriver#click_on_locator` with JS if xpath has double quotes

## 0.19.0 (2021-11-15)

### New feature

* Add Chromedriver `96.0.4664.35`

### Changes

* Use new uploader for `codecov` instead of deprecated one
* Require `mfa` for releasing gem

### Removal

* Remove support of Chrome 91

## 0.18.0 (2021-09-22)

### New feature

* Add Chromedriver `94.0.4606.41`

### Removal

* Remove support of Chrome 90

## 0.17.0 (2021-08-11)

### New Feature

* Add more details in `WebDriver#open` error

### Changes

* Remove extra refresh if `WebDriver#open` failed
* Minor refactoring - extraction `WebDriver` methods to modules

## 0.16.1 (2021-07-26)

### Fixes

* Force `-disable-gpu` for `chromedriver`

## 0.16.0 (2021-07-26)

### New Features

* Add Chromedriver `92.0.4515.43`

### Removal

* Remove Chromedriver `89.0.4389.23`

## 0.15.0 (2021-07-13)

### Changes

* Replace usage of `Kernel.open` to `URI#read`
* Replace deprecated `TimeOutError` by `TimeoutError`

## 0.14.0 (2021-05-26)

### New Features

* Add Chromedriver `91.0.4472.19`
* Add support of `rubocop-rake`
* Add support of `rubocop-packaging`

### Changes

* Default `chromedriver` version is latest, not fixed by constant
* CI run `markdownlint` check before any other checks

## 0.13.0 (2021-04-15)

### New Features

* Add Chromedriver `90.0.4430.24`

### Removal

* Remove Chromedriver 87 and 88

## 0.12.0 (2021-03-15)

### Fixes

* Do not forever hangup of Timeout Error while `get_url`

## 0.11.0 (2021-03-03)

### New Features

* Add Chromedriver `89.0.4389.23`

## 0.10.0 (2021-01-20)

### New Features

* Add Chromedriver `88.0.4324.27`

### Changes

* Use `--fail-fast` in default `spec` task

## 0.9.0 (2020-11-28)

### Changes

* Allow more generic versions in `gemspec`

## 0.8.1 (2020-11-20)

### Fixes

* Fix failure with incorrect `chromedriver` bin location

## 0.8.0 (2020-11-20)

### New Features

* Add ability to get chrome version
* Add ability to run `chromedriver` of different version
* Add option to `WebDriver.new` to not start option

### Changes

* Update `geckodriver` to `0.28.0`
* Fix firefox `Webdriver#click_on_locator_coordinates` test
  to not rely on google
* Move repo to `ONLYOFFICE-QA` organization  

## 0.7.0 (2020-11-18)

### New Features

* Add `dependabot` config

### Changes

* Update ChromeDriver to `87.0.4280.20`
* Change test for `WebDriver#element_size_by_js`
* Freeze development gem version in `Gemfile.lock`

## 0.6.3 (2020-09-11)

### New Features

* Actualize dependencies

## 0.6.2 (2020-09-11)

### New Features

* Actualize dependencies

## 0.6.1 (2020-09-03)

### New Features

* Add `record_video` option to `WebDriver.new`

### Changes

* Remove unused `_remote_server` param of `WebDriver.new`
* `WebDriver.new` arguments are `params` hash

## 0.6.0 (2020-09-03)

### New Feature

* Ability to record video via `headless` gem

## 0.5.0 (2020-08-26)

### New Features

* Use GitHub Actions instead of TravisCI
* Add `rubocop` checks in CI
* Fixes from update `rubocop` to `0.89.1`
* Update chromedriver to `85.0.4183.83`

### Fixes

* Fix `wait_until` test to not to use not-existing localhost page
* Add sleep for page to open
  Without it on newest chrome troubles with setting focus

### Changes

* Freeze exact version of gem dependencies
  to correct update via Dependabot
* Drop support of rubies older, than 2.5, since
  they are EOLed
* Remove `w3c: false` fro Chrome start options
* Force install current stable Chrome in CI

## 0.4.0 (2020-07-30)

### New Features

* Add some missing documentation
* Add tests to `WebDriver#set_attribute`
* Add tests to `WebDriver#remove_attribute`

### Fixes

* Fix `rubocop` issues after upgrade to 0.88.0
* Fix `WebDriver#remove_attribute` for xpath with double quotes
* Fix `WebDriver#get_text_by_js` for `//input` tags

### Changes

* Remove unused `WebDriver#server_address`
* Refactor location of `WebDriver#set_parameter`
  and `WebDriver#remove_attribute`
* Rename `WebDriver#set_parameter` to `WebDriver#set_attriubte`.
  Keep old name as alias
* Use `WebDriver#dom_element_by_xpath` in `WebDriver#set_attribute`

## 0.3.5 (2020-07-15)

### Fixes

* Fix `WebDriver#set_style_attribute` for xpath with single quotes

### Changes

* Extract `WebDriver#set_style_attribute` test to separate spec
* Extract `WebDriver#set_style_show_by_xpath` test to separate spec
* Extract `WebDriver#set_style_parameter` test to separate spec
* Simplify `WebDriver#set_style_show_by_xpath` by using `dom_element_by_xpath`
* `WebDriver#set_style_parameter` just an alias to `WebDriver#set_style_attribute`

## 0.3.4 (2020-07-06)

### Changes

* Remove unused `WebDriver#remove_event`
* Remove unused `WebDriver#add_class_by_jquery`
* Remove unused `WebDriver#remove_class_by_jquery`
* Remove unused `WebDriver#get_host_name`
* Remove unused `WebDriver#service_unavailable?`
* Remove unused `WebDriver.host_name_by_full_url`

## 0.3.3 (2020-07-03)

### Fixes

* Add documentation to some methods

### Changes

* Extract click methods to `ClickMethods` module
* Increase test coverage of `ClickMethods` module
* Remove `WebDriver#click_and_wait`
* `WebDriver#click_on_locator` raise `Selenium::WebDriver::Error::ElementNotVisibleError`
  instead of `RuntimeError`
* `WebDriver#click_on_displayed` raise a correct exception type if failed
* Remove unused `WebDrvier#click_on_one_of_several_by_text`,
  `WebDriver#click_on_one_of_several_xpath_by_number`,
  `WebDriver#left_mouse_click`
* `WebDriver#right_click` wait to element to appear
* Remove `WebDriver#context_click_on_locator` -
  use `WebDriver#right_click` instead

## 0.3.2 (2020-06-30)

### Changes

* `WebDriver#wait_until_element_disappear`, `WebDriver#wait_until_element_present`
   has option of timeout
* `WebDriver#wait_until_element_disappear`, `WebDriver#wait_until_element_present`
   raise `TimeOutError` instead of `RuntimeError`
* Extract `wait_until*` methods to separate module

## 0.3.1 (2020-06-03)

### Fixes

* Fix taking screenshot inside headless
* Fix `markdownlint` check in CI

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
