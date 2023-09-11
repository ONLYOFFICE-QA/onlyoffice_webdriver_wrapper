# frozen_string_literal: true

require_relative 'lib/onlyoffice_webdriver_wrapper/name'
require_relative 'lib/onlyoffice_webdriver_wrapper/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeWebdriverWrapper::Name::STRING
  s.version = OnlyofficeWebdriverWrapper::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov', 'Oleg Nazarov', 'Dmitry Rotaty']
  s.email = %w[shockwavenn@gmail.com]
  s.summary = 'ONLYOFFICE Webdriver Wrapper Gem'
  s.description = 'ONLYOFFICE Webdriver Wrapper Gem. Used in QA'
  s.homepage = "https://github.com/ONLYOFFICE-QA/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage,
    'rubygems_mfa_required' => 'true'
  }
  s.files = Dir['lib/**/*']
  s.license = 'AGPL-3.0'
  s.add_runtime_dependency('headless', '~> 2')
  s.add_runtime_dependency('onlyoffice_file_helper', '< 2')
  s.add_runtime_dependency('onlyoffice_logger_helper', '~> 1')
  s.add_runtime_dependency('onlyoffice_s3_wrapper', '< 2', '>= 0.5.0')
  s.add_runtime_dependency('page-object', '~> 2')
  # Do not use selenium-webdriver v4.12.0 because
  # of this bug: https://github.com/SeleniumHQ/selenium/issues/12659
  s.add_runtime_dependency('selenium-webdriver', '~> 4')
  s.add_runtime_dependency('watir', '~> 7')
end
