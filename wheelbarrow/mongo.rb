require 'mongo'
require_relative 'wheelbarrow'

client = Mongo::Client.new ['mongo']
Mongo::Logger.logger.level = Logger::FATAL

# db = client.database

c = client[:plants]
require 'pry'; binding.pry
# data = Marshal.load File.read 'spec/fixtures/raw-csv.marshal'
# w = Wheelbarrow::Wrangler.new data 

# w.each do |p| 
#     c.find_one_and_replace({ _id: p.identifier}, {'$set': p}, options= {upsert: true}) 
# end

