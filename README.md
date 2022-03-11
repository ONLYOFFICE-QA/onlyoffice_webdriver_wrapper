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
