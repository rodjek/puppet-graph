require 'rspec/autorun'
require 'puppet-graph'
require 'simplecov'

SimpleCov.start do
  add_filter '/vendor/gems/'
end

RSpec.configure do |c|
  c.mock_framework = :rspec
end
