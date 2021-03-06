require 'rake'
require 'rubygems/package_task'
require 'thor/group'
require File.expand_path('../core/lib/generators/gaku/install/install_generator', __FILE__)
begin
  require 'gaku/testing/common_rake'
rescue LoadError
  raise 'Could not find gaku/testing/common_rake. You need to run this command using Bundler.'
end

functional_engines = %w( core frontend admin archive )
all_engines = %w( core frontend admin archive testing sample )

task default: :all_specs

spec = eval(File.read('gaku.gemspec'))
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc 'Generates a dummy app for testing for every GAKU engine'
task :test_app do
  functional_engines.each do |engine|
    ENV['LIB_NAME'] = File.join('gaku', engine)
    ENV['DUMMY_PATH'] = File.expand_path("../#{engine}/spec/dummy", __FILE__)
    Rake::Task['common:test_app'].execute
  end
end

desc 'Clean the whole repository by removing all the generated files'
task :clean do
  puts 'Deleting pkg directory..'
  FileUtils.rm_rf('pkg')

  all_engines.each do |gem_name|
    puts "Cleaning #{gem_name}:"
    puts "  Deleting #{gem_name}/Gemfile"
    FileUtils.rm_f("#{gem_name}/Gemfile")
    puts "  Deleting #{gem_name}/pkg"
    FileUtils.rm_rf("#{gem_name}/pkg")
    puts "  Deleting #{gem_name}'s dummy application"
    Dir.chdir("#{gem_name}/spec") do
      FileUtils.rm_rf('dummy')
    end
  end
end

namespace :gem do
  desc 'run rake gem for all gems'
  task :build do
    all_engines.each do |gem_name|
      puts "########################### #{gem_name} #########################"
      puts "Deleting #{gem_name}/pkg"
      FileUtils.rm_rf("#{gem_name}/pkg")
      cmd = "cd #{gem_name} && bundle exec rake gem"
      puts cmd
      system cmd
    end
    puts 'Deleting pkg directory'
    FileUtils.rm_rf('pkg')
    cmd = 'bundle exec rake gem'
    puts cmd
    system cmd
  end
end

namespace :gem do
  desc 'run gem install for all gems'
  task :install do
    version = File.read(File.expand_path('../VERSION', __FILE__)).strip

    all_engines.each do |gem_name|
      puts "########################### #{gem_name} #########################"
      puts "Deleting #{gem_name}/pkg"
      FileUtils.rm_rf("#{gem_name}/pkg")
      cmd = "cd #{gem_name} && bundle exec rake gem"
      puts cmd
      system cmd

      cmd = "cd #{gem_name}/pkg && gem install gaku_#{gem_name}-#{version}.gem"
      puts cmd
      system cmd
    end
    puts 'Deleting pkg directory'
    FileUtils.rm_rf('pkg')
    cmd = 'bundle exec rake gem'
    puts cmd
    system cmd

    cmd = "gem install pkg/gaku-#{version}.gem"
    puts cmd
    system cmd
  end
end

namespace :gem do
  desc 'Release all gems to gemcutter. Package gaku components, then push gaku'
  task :release do
    version = File.read(File.expand_path('../VERSION', __FILE__)).strip

    all_engines.each do |gem_name|
      puts "########################### #{gem_name} #########################"
      cmd = "cd #{gem_name}/pkg && gem push gaku_#{gem_name}-#{version}.gem"
      puts cmd
      system cmd
    end
    cmd = "gem push pkg/gaku-#{version}.gem"
    puts cmd
    system cmd
  end
end
