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
  module Sequel::Model::ClassMethods
    def call(values)
      o = allocate
      o.instance_variable_set(:@values, values)
      o.instance_variable_set(:@new, nil)
      o.instance_variable_set(:@modified, nil)
      o.instance_variable_set(:@singleton_setter_added, nil)
      o.instance_variable_set(:@errors, nil)
      o.instance_variable_set(:@this, nil)
      o.instance_variable_set(:@server, nil)
      o.instance_variable_set(:@skip_validation_on_next_save, nil)
      o.instance_variable_set(:@changed_columns, nil)
      o
    end
  end 

  module Sequel::Model::Associations::ClassMethods
    def call(values)
      o = super
      o.instance_variable_set(:@associations, nil)
      o.instance_variable_set(:@set_associated_object_if_same, nil)
      o
    end
  end

  if ARGV.last == 'plugin'
    module Sequel::Plugins
      module AccessedColumns
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@accessed_columns, nil)
            o
          end
        end
      end

      module ActiveModel
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@_to_partial_path, nil)
            o.instance_variable_set(:@destroyed, nil)
            o.instance_variable_set(:@rollback_checker, nil)
            o
          end
        end
      end

      module AssociationPks
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@_association_pks, nil)
            o
          end
        end
      end

      module AutoValidations
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@_skip_auto_validations, nil)
            o
          end
        end
      end

      module ColumnsUpdated
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@columns_updated, nil)
            o
          end
        end
      end

      module Composition
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@compositions, nil)
            o
          end
        end
      end

      module Dirty
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@initial_values, nil)
            o.instance_variable_set(:@missing_initial_values, nil)
            o.instance_variable_set(:@previous_changes, nil)
            o
          end
        end
      end

      module ForbidLazyLoad
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@forbid_lazy_load, nil)
            o
          end
        end
      end

      module InsertConflict
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@insert_conflict_opts, nil)
            o
          end
        end
      end

      module InstanceFilters
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@instance_filters, nil)
            o
          end
        end
      end

      module InstanceHooks
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@instance_hooks, nil)
            o
          end
        end
      end

      module JsonSerializer
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@json_serializer_opts, nil)
            o
          end
        end
      end

      module Serialization
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@deserialized_values, nil)
            o
          end
        end
      end

      module SerializationModificationDetection
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@original_deserialized_values, nil)
            o
          end
        end
      end

      module TacticalEagerLoading
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@retrieved_by, nil)
            o.instance_variable_set(:@retrieved_with, nil)
            o
          end
        end
      end

      module UpdatePrimaryKey
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@pk_hash, nil)
            o
          end
        end
      end

      module ValidationContexts
        module ClassMethods
          def call(values)
            o = super
            o.instance_variable_set(:@validation_context, nil)
            o
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

