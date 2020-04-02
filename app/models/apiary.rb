class Apiary < ApplicationRecord
  belongs_to :user, optional: true
  has_many :hives, dependent: :destroy

  after_create :subscribe_apiary

  private

  def subscribe_apiary
    SubscribeApiaryService.call(uuids: uuid)
  end
end
