class Blacklist < ApplicationRecord
  validates :token, presence: true, uniqueness: true
end
