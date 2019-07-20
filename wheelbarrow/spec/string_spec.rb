describe String do 
    it 'cleans a string' do
        expect(' String '.clean).to eq 'string'
    end
end