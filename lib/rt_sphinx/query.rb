# encoding: utf-8

module RtSphinx
  class Query

    def initialize
      @connection = RtSphinx::Connection.instance
    end

    def select(index, clause)
      select_sql = "SELECT * FROM #{index} WHERE #{clause}"
      @connection.execute_sql(select_sql, 'select')
    end

    def insert(index, *values)
      item_id = rand(10_000)*rand(9_888)
      values_str = values.map{|v| "'#{v}'"}.join(', ')
      insert_sql = "INSERT INTO #{index} (id, timestamp, message, logjson) VALUES (#{item_id}, #{values_str})"
      @connection.execute_sql(insert_sql, 'insert')
    end
  end
end
