# frozen_string_literal: true

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

Dir[File.dirname(__FILE__) + '/factories/*.rb'].each { |file| require file }

RSpec.configure do |config|
end
