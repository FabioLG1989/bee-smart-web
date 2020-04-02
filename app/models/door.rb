class Door < ApplicationRecord
  belongs_to :hive, optional: true

  enum status: [:closed, :opened, :unknown], _prefix: true
  enum last_command: [:close, :open, :none], _prefix: true
end
