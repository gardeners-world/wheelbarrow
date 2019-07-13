require 'json'

require 'redis' 

require_relative 'auth'

module Wheelbarrow
    config = YAML.load_file 'config/config.yaml'
    sheet = YAML.load_file 'config/sheet.yaml'
    service = Auth::authed_service
    data = service.get_spreadsheet_values sheet['spreadsheet']['id'], 
                                          sheet['spreadsheet']['sheet']
    
    redis = Redis.new host: config['redis']
    redis.set 'plant-data', data.to_json
end