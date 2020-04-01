class Scale < ApplicationRecord
  belongs_to :hive
  has_many :scale_measures
end
