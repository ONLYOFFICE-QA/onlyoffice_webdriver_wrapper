# OnlyofficeWebdriverWrapper

ONLYOFFICE Webdriver Wrapper Gem. Used in QA

## Installation

Install pre-requirements

```shell script
sudo apt-get install ffmpeg
```

Add this line to your application's Gemfile:

```ruby
gem 'onlyoffice_webdriver_wrapper'
```

And then execute:

```shell script
bundle
```

Or install it yourself as:

```shell script
gem install onlyoffice_webdriver_wrapper
```

## Usage

See `spec` files to usage examples

## Update version of chromedriver exe files

If you need to update stored chromedriver exe files to version `99.0.4844.51` call

```shell
rake update_chromedriver['99.0.4844.51']
```

## Update version of geockdriver

```shell
rake update_geckodriver['0.34.0']
```

## Repos to update after release

* [testing-documentserver](https://github.com/ONLYOFFICE-QA/testing-documentserver)
* [testing-onlyoffice](https://github.com/ONLYOFFICE-QA/testing-onlyoffice)
* [testing-site-onlyoffice](https://github.com/ONLYOFFICE-QA/testing-site-onlyoffice)
* [testing-docspace](https://github.com/ONLYOFFICE-QA/testing-docspace)
* [testing-helpcenter](https://github.com/ONLYOFFICE-QA/testing-helpcenter)
* [testing-api.onlyoffice.com](https://github.com/ONLYOFFICE-QA/testing-api.onlyoffice.com)
