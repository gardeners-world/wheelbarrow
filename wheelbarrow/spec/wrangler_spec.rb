module Wheelbarrow
    describe Wrangler do
        let(:raw_data) { Marshal.load File.read 'spec/fixtures/raw-csv.marshal' }
        let(:wrangler) { described_class.new raw_data }

        it 'is an Array' do 
            expect(wrangler).to be_an Array
        end

        it 'has the correct headers' do 
            expect(wrangler.headers).to eq [
                "plant", 
                "variety", 
                "plant_type", 
                "common_name", 
                "wikipedia_url", 
                "imgur_url", 
                "number", 
                "ph", 
                "water", 
                "fertiliser"
            ]
        end

        context 'correct data' do 
            specify 'the first plant is correct' do
                expect(wrangler.first).to be_a Plant
                expect(wrangler.first).to eq ({
                    "plant"=>"alocasia",
                    "variety"=>"zebrina",
                    "plant_type"=>"tropical",
                    "common_name"=>[
                        "elephant ears"
                    ],
                    "wikipedia_url"=>"https://en.wikipedia.org/wiki/alocasia",
                    "imgur_url"=>"",
                    "number"=>"",
                    "ph"=>"",
                    "water"=>"",
                    "fertiliser"=>""
                })
                expect(wrangler.first.identifier).to eq 'alocasia::zebrina'
            end

            it 'returns a plant by id' do 
                expect(wrangler.plant_by_id('fatsia::japonica')['common_name']).to eq [
                    "glossy leaf paper plant", 
                    "false castor oil plant"
                ]
            end

            specify 'a plant from a blank first field is correct' do 
                expect(wrangler.plant_by_id 'alocasia::amazonica').to eq ({
                    "plant"=>"alocasia",
                    "variety"=>"amazonica",
                    "plant_type"=>"tropical",
                    "common_name"=>[],
                    "wikipedia_url"=>"",
                    "imgur_url"=>"",
                    "number"=>"",
                    "ph"=>"",
                    "water"=>"",
                    "fertiliser"=>""
                })
            end

            specify 'a plant from sparse data is correct' do 
                expect(wrangler.plant_by_id 'cactus').to eq ({
                    "plant"=>"cactus",
                    "variety"=>"",
                    "plant_type"=>"",
                    "common_name"=>[],
                    "wikipedia_url"=>"",
                    "imgur_url"=>"",
                    "number"=>"",
                    "ph"=>"",
                    "water"=>"",
                    "fertiliser"=>""
                })
            end
        end

        context 'store in mongo' do
            let(:collection) { MongoClient::instance.collection }

            before :each do 
                wrangler.store
            end

            it 'stores the data' do
                expect(collection.count).to eq 50
            end

            it 'stores the data idempotently' do 
                wrangler.store
                expect(collection.count).to eq 50
            end
            
            it 'stores the correct data' do
                expect(collection.find(_id: 'juncus::spiralis').each.first).to eq ({
                    "_id"=>"juncus::spiralis", 
                    "common_name"=>["corkscrew rush"], 
                    "fertiliser"=>"", 
                    "imgur_url"=>"", 
                    "number"=>"", 
                    "ph"=>"",
                    "plant"=>"juncus", 
                    "plant_type"=>"", 
                    "variety"=>"spiralis", 
                    "water"=>"", 
                    "wikipedia_url"=>""
                })
            end

            it 'updates the data' do
                plant = wrangler.plant_by_id 'cactus'
                plant['plant_type'] = 'succulent'
                plant.save  
                
                expect(collection.find(_id: 'cactus').each.first).to eq ({
                    "_id"=>"cactus", 
                    "common_name"=>[], 
                    "fertiliser"=>"", 
                    "imgur_url"=>"", 
                    "number"=>"", 
                    "ph"=>"",
                    "plant"=>"cactus", 
                    "plant_type"=>"succulent", 
                    "variety"=>"", 
                    "water"=>"", 
                    "wikipedia_url"=>""
                })
            end
        end
    end
end