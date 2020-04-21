class ScaleMeasure < ApplicationRecord
  belongs_to :scale
  delegate :calibrated, :tare, :slope, to: :scale, prefix: true
  delegate :hive, to: :scale, allow_nil: true
  delegate :id, to: :hive, allow_nil: true, prefix: true
  delegate :apiary, to: :hive, allow_nil: true
  delegate :id, to: :apiary, allow_nil: true, prefix: true
  after_create :set_value

  def self.to_csv(ids)
    attributes = %w{ apiary_id hive_id raw weight scale_tare scale_slope measured_at }

    CSV.generate(headers: true) do |csv|
      csv << attributes

      ScaleMeasure.where(id: ids).each do |measure|
        csv << attributes.map { |attr| measure.send(attr) }
      end
    end
  end

  def value
    return weight if scale_calibrated
    raw
  end

  private

  def set_value
    return unless scale_calibrated
    weight = (raw - scale_tare) / scale_slope
    update!(weight: weight)
  end
end
