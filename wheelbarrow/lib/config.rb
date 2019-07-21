require 'ostruct'
require 'singleton'

module Wheelbarrow
    class Config
        include Singleton
  
        def config
            @config ||= begin
                env = ENV['RUBY_ENV'] || 'development'  
                OpenStruct.new fetch_yaml File.join env
            end
        end
  
        private
  
        def fetch_yaml env
            YAML.load(File.open(File.join(File.dirname(__FILE__), '..', 'config/environments/%s.yaml' % env)))
        end
    end
end