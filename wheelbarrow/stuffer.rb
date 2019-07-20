require 'base64'
require 'json'

require 'redis' 

require_relative 'auth'

module Wheelbarrow
    config = YAML.load_file 'config/config.yaml'
    sheet = YAML.load_file 'config/sheet.yaml'
    service = Auth::authed_service
    data = service.get_spreadsheet_values sheet['spreadsheet']['id'], 
                                          sheet['spreadsheet']['sheet']
                                          require 'pry'; binding.pry
    redis = Redis.new host: config['redis']
    redis.set 'plant-data', (Base64.encode64 data.values.to_json)
end