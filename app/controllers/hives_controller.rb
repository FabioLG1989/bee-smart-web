class HivesController < ApplicationController
  before_action :set_hive, only: [:show, :edit, :update, :destroy, :open, :close]

  def show
  end

  def close
    @hive&.door&.last_command_close!
    DoorActuateCommandService.call(@hive&.door)
    redirect_to hive_path(@hive)
  end

  def open
    @hive&.door&.last_command_open!
    DoorActuateCommandService.call(@hive&.door)
    redirect_to hive_path(@hive)
  end

  private

  def set_hive
    @hive = Hive.find(params[:id])
  end
end
