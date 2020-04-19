class Apiary < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :hives, dependent: :destroy
  has_many :messages, through: :hives

  after_create :subscribe_apiary

  private

  def subscribe_apiary
    SubscribeApiaryService.call(uuids: uuid)
  end
end
