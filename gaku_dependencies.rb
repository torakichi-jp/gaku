source 'http://production.s3.rubygems.org'

#gem 'phantom_helpers', path: '../../phantom_helpers'
#gem 'phantom_forms', path: '../../phantom_forms'

gem 'phantom_helpers', github: 'kalkov/phantom_helpers'
gem 'phantom_forms',   github: 'kalkov/phantom_forms'

group :development do
  gem 'guard'
  gem 'rubocop'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-rubocop'
end

group :test do
  gem 'simplecov'
  gem 'coveralls', require: false
end

gemspec