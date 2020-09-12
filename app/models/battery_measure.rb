class BatteryMeasure < ApplicationRecord
  belongs_to :battery
  delegate :hive, to: :battery, allow_nil: true
  delegate :id, to: :hive, allow_nil: true, prefix: true
  delegate :apiary, to: :hive, allow_nil: true
  delegate :id, to: :apiary, allow_nil: true, prefix: true

  def self.to_csv(ids)
    attributes = %w{ apiary_id hive_id voltage measured_at }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      BatteryMeasure.where(id: ids).each do |measure|
        csv << attributes.map { |attr| measure.send(attr) }
      end
    end
  end
end
