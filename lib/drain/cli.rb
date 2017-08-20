# frozen_string_literal: true
require 'drain/cli/version'
require 'thor'
require 'date'
require 'sequel'

DB = Sequel.connect('sqlite://drain.db')

require 'drain/cli/schema'
require 'drain/cli/reading'

module Drain
  module Cli
    # Entrypoint to everything to come
    class Main < Thor
      desc 'add USAGE', 'add consumption reading'
      method_option :date,  aliases: '-d',
                            desc: 'Date of reading, if not today (JJJJ-MM-TT)'
      def add(usage)
        date = options[:date] || Date.today
        Reading.create(usage: usage, date: date)
        puts "Added #{usage} on #{date}"
      end

      desc 'readings', 'print last n readings'
      method_option :number,  aliases: '-n',
                              desc: 'Defines how many readings to print'
      def readings
        n = options[:number] || 10
        readings = Reading.order(:date).reverse.limit(n)
        readings.each do |reading|
          puts "#{reading.date}: #{reading.usage} kWh"
        end
      end

      desc 'delete DATE', 'delete readings for date'
      def delete(date)
        readings = Reading.where(date: Date.parse(date))
        puts "Removed #{readings.count} readings."
        readings.each(&:delete)
      end

      desc 'purge', 'deletes everything'
      def purge
        Reading.all.map(&:delete)
      end

      desc 'import FILE', 'imports legacy text file'
      def import(file)
        file = File.open(file).read
        file.each_line do |line|
          result = line.match(/(\d*\.\d*.\d*.) - ([\d\.]*)/)
          next unless result
          date = Date.parse(Regexp.last_match(1))
          usage = Regexp.last_match(2).delete('.').to_i
          Reading.create(usage: usage, date: date)
        end
      end

      desc 'average', 'prints average since last reading'
      method_option :date,  aliases: '-d',
                            desc: 'Date of reference reading'
      def average
        reference = reference_for_date(options[:date])
        last = Reading.order(:date).reverse.first
        puts "#{reference.date}: #{reference.usage}"
        puts "#{last.date}: #{last.usage}"
        avg = (last.usage - reference.usage) /
              (reference.date...last.date).count.to_f
        puts "Average consumption from #{reference.date} to #{last.date}: \n"
        puts "#{avg} kWh/day"
      end

      private

      def reference_for_date(date)
        if date
          Reading.filter(
            Sequel.lit('date >= ?', Date.parse(options[:date]).to_s)
          ).first
        else
          Reading.order(:date).reverse.limit(2).to_a.last
        end
      end
    end
  end
end
