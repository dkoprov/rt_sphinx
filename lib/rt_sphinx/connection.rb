# encoding: utf-8
require 'singleton'
require 'connection_pool'

require 'date'
require 'bigdecimal'

module RtSphinx
  class Connection
    include Singleton

    def self.instance
      @@instance ||= new
    end

    def initialize
      @pool = ConnectionPool.new(:size => 5, :timeout => 5) do
        if RUBY_PLATFORM =~ /java/
          require 'jdbc/mysql'
          Jdbc::MySQL.load_driver(:require) if Jdbc::MySQL.respond_to?(:load_driver)
          url = "jdbc:mysql://127.0.0.1:9327?characterEncoding=utf8&maxAllowedPacket=512000"
          conn = java.sql.DriverManager.getConnection(url, "", "")
        else
          require 'mysql2'
          Mysql2::Client.new(
            :host => '127.0.0.1',
            :port => 9327,
            :encoding => 'utf8'
          )
        end
      end
    end

    def execute_sql(sql, mode)
      res = {}
      @pool.with do |connection|
        if RUBY_PLATFORM =~ /java/
          st = connection.create_statement
          res = case mode
                when 'select'
                  resultset_to_hash(st.execute_query(sql))
                when 'insert'
                  st.execute_update(sql)
                end
          st.close
        else
          res = connection.query(sql)
        end
      end

      res
    end

    private
    def resultset_to_hash(resultset)
      meta = resultset.meta_data
      rows = []

      while resultset.next
        row = {}

        (1..meta.column_count).each do |i|
          name = meta.column_name i
          row[name]  =  case meta.column_type(i)
                        when -6, -5, 5, 4
                          # TINYINT, BIGINT, INTEGER
                          resultset.get_int(i).to_i
                        when 41
                          # Date
                          resultset.get_date(i)
                        when 92
                          # Time
                          resultset.get_time(i).to_i
                        when 93
                          # Timestamp
                          resultset.get_timestamp(i)
                        when 2, 3, 6
                          # NUMERIC, DECIMAL, FLOAT
                          case meta.scale(i)
                          when 0
                            resultset.get_long(i).to_i
                          else
                            BigDecimal.new(resultset.get_string(i).to_s)
                          end
                        when 1, -15, -9, 12
                          # CHAR, NCHAR, NVARCHAR, VARCHAR
                          resultset.get_string(i).to_s
                        else
                          resultset.get_string(i).to_s
                        end
        end

        rows << row
      end
      rows
    end
  end
end
