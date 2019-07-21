require_relative 'lib/config'
require_relative 'lib/mongo_client'
require_relative 'lib/plant'
require_relative 'lib/string'
require_relative 'lib/wrangler'

module Wheelbarrow
    def Wheelbarrow.divide values
        values.split(',').map! do |v| 
            v.clean
        end
    end
end