# frozen_string_literal: true
module Drain
  module Cli
    class Schema
      DB.create_table?(:readings) do
        primary_key :id
        Integer :usage, null: false
        Date :date, unique: true, null: false
      end
    end
  end
end
