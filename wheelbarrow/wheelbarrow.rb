require 'mongo'

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