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
      @values = values
      @new = nil
      @modified = nil
      @singleton_setter_added = nil
      @errors = nil
      @this = nil
      @server = nil
      @skip_validation_on_next_save = nil
      @changed_columns = nil
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
      @associations = nil
      @set_associated_object_if_same = nil
    end
  end

  if ARGV.last == 'plugin'
    module Sequel::Plugins
      module AccessedColumns
        module InstanceMethods
          def init_with(values)
            super
            @accessed_columns = nil
          end
        end
      end

      module ActiveModel
        module InstanceMethods
          def init_with(values)
            super
            @_to_partial_path = nil
            @destroyed = nil
            @rollback_checker = nil
          end
        end
      end

      module AssociationPks
        module InstanceMethods
          def init_with(values)
            super
            @_association_pks = nil
          end
        end
      end

      module AutoValidations
        module InstanceMethods
          def init_with(values)
            super
            @_skip_auto_validations = nil
          end
        end
      end

      module ColumnsUpdated
        module InstanceMethods
          def init_with(values)
            super
            @columns_updated = nil
          end
        end
      end

      module Composition
        module InstanceMethods
          def init_with(values)
            super
            @compositions = nil
          end
        end
      end

      module Dirty
        module InstanceMethods
          def init_with(values)
            super
            @initial_values = nil
            @missing_initial_values = nil
            @previous_changes = nil
          end
        end
      end

      module ForbidLazyLoad
        module InstanceMethods
          def init_with(values)
            super
            @forbid_lazy_load = nil
          end
        end
      end

      module InsertConflict
        module InstanceMethods
          def init_with(values)
            super
            @insert_conflict_opts = nil
          end
        end
      end

      module InstanceFilters
        module InstanceMethods
          def init_with(values)
            super
            @instance_filters = nil
          end
        end
      end

      module InstanceHooks
        module InstanceMethods
          def init_with(values)
            super
            @instance_hooks = nil
          end
        end
      end

      module JsonSerializer
        module InstanceMethods
          def init_with(values)
            super
            @json_serializer_opts = nil
          end
        end
      end

      module Serialization
        module InstanceMethods
          def init_with(values)
            super
            @deserialized_values = nil
          end
        end
      end

      module SerializationModificationDetection
        module InstanceMethods
          def init_with(values)
            super
            @original_deserialized_values = nil
          end
        end
      end

      module TacticalEagerLoading
        module InstanceMethods
          def init_with(values)
            super
            @retrieved_by = nil
            @retrieved_with = nil
          end
        end
      end

      module UpdatePrimaryKey
        module InstanceMethods
          def init_with(values)
            super
            @pk_hash = nil
          end
        end
      end

      module ValidationContexts
        module InstanceMethods
          def init_with(values)
            super
            @validation_context = nil
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

