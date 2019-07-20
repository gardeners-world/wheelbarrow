module Wheelbarrow 
    class Plant < Hash
        def initialize fields, data
            fields.each_with_index do |field, index|
                item = data[index]
                item = '' unless item
                if ['common_name'].include? field
                    item = Wheelbarrow.divide item
                else
                    item = item.clean
                end
                self[field] = item
            end
        end

        def identifier
            id = "#{self['plant']}"
            id = "#{id}::#{self['variety']}" if self['variety'] != ''
            id
        end
    end
end