class Match < ApplicationRecord
    has_many :participants

    before_validation :transform_date, on: [:create, :update]

    attr_accessor :date_day, :date_month, :date_year
    attr_reader :date_day, :date_month, :date_year

    def transform_date
        return unless date_day && date_month && date_year
        days_since_1970 = Date.new(date_year.to_i, date_month.to_i, date_day.to_i).strftime(format='%s').to_i / (60 * 60 * 24)
        self.day = days_since_1970
    end

    def human_date
        DateTime.strptime( (self.day * 60 * 60 * 24).to_s, '%s').to_date
    end
end
