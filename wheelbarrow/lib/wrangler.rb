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
            collection = MongoClient::instance.collection

            self.each do |plant| 
                plant.save
            end
        end
    end
end