class Apiary < ApplicationRecord
  belongs_to :user, optional: true
  has_many :hives
end
