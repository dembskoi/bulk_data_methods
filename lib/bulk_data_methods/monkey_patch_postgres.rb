require 'active_record'
require 'active_record/base'
require 'active_record/connection_adapters/abstract_adapter'
require 'active_record/connection_adapters/postgresql_adapter'

module ActiveRecord::ConnectionAdapters
  class PostgreSQLAdapter < AbstractAdapter
    #
    # Get the next value in a sequence. Used on INSERT operation for
    # partitioning like by_id because the ID is required before the insert
    # so that the specific child table is known ahead of time.
    #
    # @param [String] sequence_name the name of the sequence to fetch the next value from
    # @return [Integer] the value from the sequence
    def next_sequence_value(sequence_name)
      return execute("select nextval('#{sequence_name}')").field_values("nextval").first.to_i
    end

    #
    # Get the some next values in a sequence.
    #
    # @param [String] sequence_name the name of the sequence to fetch the next values from
    # @param [Integer] batch_size count of values.
    # @return [Array<Integer>] an array of values from the sequence
    def next_sequence_values(sequence_name, batch_size)
      result = execute("select nextval('#{sequence_name}') from generate_series(1, #{batch_size})")
      return result.field_values("nextval").map(&:to_i)
    end
  end
end
