require_relative 'lib/auth'
require_relative 'wheelbarrow'

module Wheelbarrow
    def fetcher
        sheet = YAML.load_file 'config/sheet.yaml'
        service = Auth::authed_service
        data = service.get_spreadsheet_values sheet['spreadsheet']['id'], 
                                            sheet['spreadsheet']['sheet']
                                            require 'pry'; binding.pry
        wrangler = Wrangler.new data.values 
        wrangler.store
    end
end