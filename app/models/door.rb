class Door < ApplicationRecord
  belongs_to :hive, optional: true

  enum status: [:closed, :opened, :unknown], _prefix: true
  enum last_command: [:close, :open, :none], _prefix: true

  def status_to_s
    return 'Cerrada' if status_closed?
    return 'Abierta' if status_opened?
    return 'Desconocido' if status_unknown?
  end

  def last_command_to_s
    return 'Cerrar' if last_command_close?
    return 'Abrir' if last_command_open?
    return nil if last_command_none?
  end
end
