class Player < ApplicationRecord
	has_secure_password

	validates :email, uniqueness: true, email: true
end
