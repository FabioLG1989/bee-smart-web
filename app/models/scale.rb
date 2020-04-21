class Scale < ApplicationRecord
  belongs_to :hive
  has_many :scale_measures, dependent: :destroy
  validates :graph_points, presence: true, numericality: true

  def last_weight_measure
    scale_measures.last&.value
  end

  def last_weight_measure_date
    scale_measures.last&.measured_at
  end

  def calibrated
    return true if tare && slope
    false
  end

  def graph_data
    graph_data = {}
    scale_measures.last(graph_points).each do |measure|
      graph_data[measure.measured_at] = measure.value if measure.value
    end
    graph_data
  end

  def csv_collection
    scale_measures.last(graph_points)
  end
end
