require_relative '../wheelbarrow'

ENV['RUBY_ENV'] = 'test'

module Wheelbarrow
    RSpec.configure do |config|
        config.before :each do 
            collection = MongoClient::instance.collection
            collection.drop
        end
    end
end