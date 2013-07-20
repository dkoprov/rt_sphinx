require_relative 'connection'
require_relative 'query'

class RtSphinx
  def initialize(host, port)
    @pool = ConnectionPool.new(:size => 5, :timeout => 5) do
      if RUBY_PLATFORM =~ /java/
        require 'jdbc/mysql'
        Jdbc::MySQL.load_driver(:require) if Jdbc::MySQL.respond_to?(:load_driver)
        url = "jdbc:mysql://#{host}:#{port}?characterEncoding=utf8&maxAllowedPacket=512000"
        conn = java.sql.DriverManager.getConnection(url, "", "")
      else
        require 'mysql2'
        Mysql2::Client.new(
          :host => address,
          :port => port
        )
      end
    end
  end

  def insert(index, columns = [], values = [])
    # TODO: escape values
    # TODO: create an id
    # TODO: work with JSON values
    insert_sql = "INSERT INTO #{index} (`#{columns.join('`, `')}`) VALUES (#{values})"

    @pool.with do |connection|
      if RUBY_PLATFORM =~ /java/
        st = connection.create_statement
        st.execute_update(insert_sql)
        st.close
      else
        connection.query(insert_sql)
      end
    end
  end

  def values_to_s
    values.collect { |value_set|
      value_set.collect { |value|
        translated_value(value)
      }.join(', ')
    }.join('), (')
  end

  def translated_value(value)
    case value
    when String
      "'#{value.gsub(/['\\]/, '').gsub(/\s+/, ' ')}'"
    when TrueClass, FalseClass
      value ? 1 : 0
    when Time
      value.to_i
    when Array
      "(#{value.join(',')})"
    else
      value
    end
  end
end
