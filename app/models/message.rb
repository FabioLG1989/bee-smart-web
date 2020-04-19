class Message < ApplicationRecord
  belongs_to :hive, optional: true
end
