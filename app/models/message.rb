class Message < ApplicationRecord
  belongs_to :hive, optional: true

  validates :raw, presence: true
end
