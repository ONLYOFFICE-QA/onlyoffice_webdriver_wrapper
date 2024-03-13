# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--fail-fast'
end

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

  linux_archive = "https://storage.googleapis.com/chrome-for-testing-public/#{args[:version]}/linux64/chromedriver-linux64.zip"
  sh("wget #{linux_archive} -O /tmp/chromedriver-linux64.zip")
  sh('unzip -o /tmp/chromedriver-linux64.zip -d /tmp')
  sh("cp /tmp/chromedriver-linux64/chromedriver #{dir_for_exe}/chromedriver_linux_#{major_version}")

  mac_archive = "https://storage.googleapis.com/chrome-for-testing-public/#{args[:version]}/mac-x64/chromedriver-mac-x64.zip"
  sh("wget #{mac_archive} -O /tmp/chromedriver-mac-x64.zip")
  sh('unzip -o /tmp/chromedriver-mac-x64.zip -d /tmp')
  sh("cp /tmp/chromedriver-mac-x64/chromedriver #{dir_for_exe}/chromedriver_mac")
end

desc 'Update Geckodriver exe'
task :update_geckodriver, [:version] do |_, args|
  dir_for_exe = "#{Dir.pwd}/lib/onlyoffice_webdriver_wrapper/helpers/bin"
  archive_name = "geckodriver-v#{args[:version]}-linux64.tar.gz"

  url = "https://github.com/mozilla/geckodriver/releases/download/v#{args[:version]}/#{archive_name}"
  sh("wget #{url} -O /tmp/#{archive_name}")
  sh("tar xvf /tmp/#{archive_name} -C /tmp")
  sh("cp /tmp/geckodriver #{dir_for_exe}/")
end
