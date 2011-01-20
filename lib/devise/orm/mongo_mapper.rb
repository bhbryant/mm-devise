require 'mongo_mapper'
require 'devise/orm/mongo_mapper/compatibility'
require 'devise/orm/mongo_mapper/schema'
require 'devise/orm/mongo_mapper/date_time'
require 'devise/orm/mongo_mapper/mm-validations'

module Devise
  module Orm
    module MongoMapper
      module Hook
        def devise_modules_hook!
          extend Schema
          include Compatibility 
          include Validatable
          yield
          return unless Devise.apply_schema

          devise_modules.each do |m|
            if respond_to?(m, true) 
              if defined?(@@orm_options) && @@orm_options.has_key?(m)
                 send(m, @@orm_options[m] ) 
               else
                 send(m)
              end
            end
          end
        end   
        
        def orm_options=(options)
          @@orm_options = options
        end
   
                     
      end
    end
  end
end
MongoMapper::Document.append_extensions(Devise::Models)
MongoMapper::Document.append_extensions(Devise::Orm::MongoMapper::Hook)

