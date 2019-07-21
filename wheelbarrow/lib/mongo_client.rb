require 'singleton'

require 'mongo'

Mongo::Logger.logger.level = Logger::FATAL

module Wheelbarrow
    class MongoClient
        include Singleton

        def client 
            @client ||= Mongo::Client.new ['mongo']
        end

        def collection
            @collection ||= client[Config.instance.config.mongo['collection']]
        end
    end 
end