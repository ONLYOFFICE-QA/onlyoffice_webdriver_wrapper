# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Release gem'
task :release_github_rubygems do
  Rake::Task['release'].invoke
  sh('gem push --key github ' \
     '--host https://rubygems.pkg.github.com/ONLYOFFICE-QA ' \
     "pkg/#{OnlyofficeWebdriverWrapper::Name::STRING}-" \
     "#{OnlyofficeWebdriverWrapper::Version::STRING}.gem")
end

desc 'Update Chromedriver exe'
task :update_chromedriver, [:version] do |_, args|
  major_version = args[:version].split('.').first
  dir_for_exe = "#{Dir.pwd}/lib/onlyoffice_webdriver_wrapper/helpers/chrome_helper/chromedriver_bin"

  linux_archive = "https://chromedriver.storage.googleapis.com/#{args[:version]}/chromedriver_linux64.zip"
  sh("wget #{linux_archive} -O /tmp/chromedriver_linux64.zip")
  sh('unzip -o /tmp/chromedriver_linux64.zip -d /tmp')
  sh("cp /tmp/chromedriver #{dir_for_exe}/chromedriver_linux_#{major_version}")

  mac_archive = "https://chromedriver.storage.googleapis.com/#{args[:version]}/chromedriver_mac64.zip"
  sh("wget #{mac_archive} -O /tmp/chromedriver_mac64.zip")
  sh('unzip -o /tmp/chromedriver_mac64.zip -d /tmp')
  sh("cp /tmp/chromedriver #{dir_for_exe}/chromedriver_mac")
end
