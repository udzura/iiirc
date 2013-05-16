# coding: utf-8
require 'rubygems'
require 'rss'

require 'simplecov'
require 'simplecov-rcov'

# Settings for coveralls: https://coveralls.io/r/iiirc/iiirc
require 'coveralls'
Coveralls.wear!
unless ENV['COVERAGE'] == 'off'
  puts 'Run with `COVERAGE=off` if you do not want to generate simplecov coverage reports.'
  require 'simplecov'
  require 'simplecov-rcov'
  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      SimpleCov::Formatter::RcovFormatter.new.format(result)
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start 'rails'
end

ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'omniauth'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include Capybara::DSL
  OmniAuth.config.test_mode = true

  config.infer_base_class_for_anonymous_controllers = true
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

Capybara.javascript_driver = :poltergeist
