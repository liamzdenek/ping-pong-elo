class Elo < ApplicationRecord
    def human_date
        DateTime.strptime( (self.day * 60 * 60 * 24).to_s, '%s').to_date
    end
end
