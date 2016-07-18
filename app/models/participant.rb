class Participant < ApplicationRecord
    has_one :match
    has_one :player
end
