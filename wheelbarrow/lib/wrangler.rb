module Wheelbarrow
    class Wrangler < Array
        attr_reader :headers 

        def initialize raw_csv
            raw_csv.delete_if { |e| e == [nil] }

            @headers = raw_csv.shift.map do |field|
                field.downcase.strip.gsub ' ', '_'
            end

            last_genus = nil
            raw_csv.each do |row|
                last_genus = row[0] if row[0] != ''
                row[0] = last_genus
                self.push Plant.new @headers, row
            end
        end

        def plant_by_id id
            self.select { |p| p.identifier == id }.first
        end

        def store
            client = Mongo::Client.new ['mongo']
            collection = client[:plants_test]

            self.each do |plant| 
                collection.find_one_and_replace(
                    { _id: plant.identifier }, 
                    { '$set': plant }, 
                    options= { upsert: true }
                ) 
            end
        end
    end
end