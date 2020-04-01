class Door < ApplicationRecord
  belongs_to :hive, optional: true
end
