class User < ApplicationRecord
  devise :database_authenticatable,  :confirmable, :registerable,
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :apiaries
  has_many :hives, through: :apiaries
end
