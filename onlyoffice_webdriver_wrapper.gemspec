# frozen_string_literal: true

require_relative 'lib/onlyoffice_webdriver_wrapper/name'
require_relative 'lib/onlyoffice_webdriver_wrapper/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeWebdriverWrapper::Name::STRING
  s.version = OnlyofficeWebdriverWrapper::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.5'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov', 'Oleg Nazarov', 'Dmitry Rotaty']
  s.email = %w[shockwavenn@gmail.com]
  s.summary = 'ONLYOFFICE Webdriver Wrapper Gem'
  s.description = 'ONLYOFFICE Webdriver Wrapper Gem. Used in QA'
  s.homepage = "https://github.com/onlyoffice-testing-robot/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage
  }
  s.files = Dir['lib/**/*']
  s.license = 'AGPL-3.0'
  s.add_runtime_dependency('headless', '2.3.1')
  s.add_runtime_dependency('onlyoffice_file_helper', '0.3.0')
  s.add_runtime_dependency('onlyoffice_logger_helper', '1.0.3')
  s.add_runtime_dependency('onlyoffice_s3_wrapper', '0.1.2')
  s.add_runtime_dependency('page-object', '2.2.6')
  s.add_runtime_dependency('selenium-webdriver', '3.142.7')
  s.add_runtime_dependency('watir', '6.17.0')
  s.add_development_dependency('codecov', '0.2.11')
  s.add_development_dependency('overcommit', '0.55.0')
  s.add_development_dependency('rake', '13.0.1')
  s.add_development_dependency('rspec', '3.9.0')
  s.add_development_dependency('rubocop', '0.90.0')
  s.add_development_dependency('rubocop-performance', '1.8.0')
  s.add_development_dependency('rubocop-rspec', '1.43.2')
end
