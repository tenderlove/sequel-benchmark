require 'benchmark/ips'
require 'sequel'

if ARGV.last == 'plugin'
  class Sequel::Model
    plugin :accessed_columns
    plugin :active_model
    plugin :association_pks
    plugin :auto_validations
    plugin :columns_updated
    plugin :composition
    plugin :dirty
    plugin :forbid_lazy_load
    plugin :insert_conflict
    plugin :instance_filters
    plugin :instance_hooks
    plugin :json_serializer
    plugin :serialization
    plugin :serialization_modification_detection
    plugin :tactical_eager_loading
    plugin :update_primary_key
    plugin :validation_contexts
  end
end

if ARGV.first == 'eager_initialize'
  module Sequel::Model::InstanceMethods
    def init_with values
    end
  end

  module Sequel::Model::ClassMethods
    def call(values)
      o = allocate
      o.init_with values
      o
    end
  end

  module Sequel::Model::Associations::InstanceMethods
    def init_with(values)
      super
    end
  end

  if ARGV.last == 'plugin'
    module Sequel::Plugins
      module AccessedColumns
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module ActiveModel
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module AssociationPks
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module AutoValidations
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module ColumnsUpdated
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module Composition
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module Dirty
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module ForbidLazyLoad
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module InsertConflict
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module InstanceFilters
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module InstanceHooks
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module JsonSerializer
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module Serialization
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module SerializationModificationDetection
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module TacticalEagerLoading
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module UpdatePrimaryKey
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end

      module ValidationContexts
        module InstanceMethods
          def init_with(values)
            super
          end
        end
      end
    end
  end
end

DB = Sequel.connect(ENV["DATABASE_URL"] || 'sqlite:/')

DB.create_table!(:ts){String :s}

class T < Sequel::Model; end

DB[:ts].import([:s], [[""]] * 1000)

Benchmark.ips do |x|
  x.report("Retrieve 1000 rows"){T.all}
end

