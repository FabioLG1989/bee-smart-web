class ScaleMeasuresChannel < ApplicationCable::Channel
  def subscribed
    scale_measure = ScaleMeasure.find(params[:id])
    stream_from 'scale_measures'
  end
end
