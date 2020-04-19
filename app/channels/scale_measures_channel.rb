class ScaleMeasureChannel < ApplicationCable::Channel
  def subscribed
    puts "\n\n\n\n\n\n\n"
    puts params
    puts "\n\n\n\n\n\n\n\n"
    scale_measure = ScaleMeasure.find(params[:id])
    stream_from 'scale_measures'
  end
end
