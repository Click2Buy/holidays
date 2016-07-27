module Holidays
  module Finder
    module Context
      class Between
        def initialize(definition_search, dates_driver_builder)
          @definition_search = definition_search
          @dates_driver_builder = dates_driver_builder
        end

        def call(start_date, end_date, regions, observed, informal)
          validate!(start_date, end_date, regions)

          dates_driver = @dates_driver_builder.call(start_date, end_date)

          holidays = []
          opts = gather_options(observed, informal)

          holidays = @definition_search.call(dates_driver, regions, opts)
          holidays = holidays.select{|holiday|holiday[:date].between?(start_date, end_date)}
          holidays.sort{|a, b| a[:date] <=> b[:date] }
        end

        private

        def validate!(start_date, end_date, regions)
          raise ArgumentError unless start_date
          raise ArgumentError unless end_date
          raise ArgumentError if regions.nil? || regions.empty?
        end

        def gather_options(observed, informal)
          opts = []

          opts << :observed if observed == true
          opts << :informal if informal == true

          opts
        end
      end
    end
  end
end
