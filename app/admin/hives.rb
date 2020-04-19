ActiveAdmin.register Hive do
  permit_params :description, :name
  menu label: 'Colmenas'

  actions :edit, :update, :show, :index

  member_action :open_door, method: :post do
    hive = Hive.find(resource.id)
    hive&.door&.last_command_open!
    DoorActuateCommandService.call(hive&.door)
    redirect_to admin_hive_path(hive)
  end

  member_action :close_door, method: :post do
    hive = Hive.find(resource.id)
    hive&.door&.last_command_close!
    DoorActuateCommandService.call(hive&.door)
    redirect_to admin_hive_path(hive)
  end

  member_action :update_scale_graph_points, method: :post do
    graph_points = params[:scale][:graph_points]
    scale_id = params[:id]
    scale = Scale.find(scale_id)
    scale.update(graph_points: graph_points)
    redirect_to admin_hive_path(scale.hive)
  end

  member_action :update_temperature_grid_graph_points, method: :post do
    graph_points = params[:temperature_grid][:graph_points]
    temperature_grid_id = params[:id]
    temperature_grid = TemperatureGrid.find(temperature_grid_id)
    temperature_grid.update(graph_points: graph_points)
    redirect_to admin_hive_path(temperature_grid.hive)
  end

  member_action :update_scale_tare, method: :post do
    scale_id = params[:id]
    scale = Scale.find(scale_id)
    return unless scale.scale_measures.last
    tare = scale.scale_measures.last.raw
    scale.update(tare: tare)
    redirect_to admin_hive_path(scale.hive)
  end

  member_action :update_scale_slope, method: :post do
    scale_id = params[:id]
    scale = Scale.find(scale_id)
    known_weight = params[:scale][:known_weight]&.to_i
    return unless known_weight && known_weight != 0
    return unless scale.scale_measures.last && scale.tare
    slope = (scale.scale_measures.last.raw - scale.tare) / known_weight
    scale.update(slope: slope)
    redirect_to admin_hive_path(scale.hive)
  end

  member_action :export_csv, method: :post do
    class_name = params[:class_name]
    hive = Hive.find(params[:id])

    case class_name
    when 'temperature'
      collection = hive.temperature_grid_csv_collection
      klass = TemperatureMeasure
    when 'weight'
      collection = hive.scale_csv_collection
      klass = ScaleMeasure
    end

    respond_to do |format|
      format.csv { send_data klass.to_csv(collection.pluck(:id)), filename: "#{class_name}-#{Time.current}.csv" }
      format.html { send_data klass.to_csv(collection.pluck(:id)), filename: "#{class_name}-#{Time.current}.csv" }
    end
  end

  controller do
    def scoped_collection
      current_user.hives
    end
  end

  index do
    column :uuid do |hive|
      link_to hive.uuid, admin_hive_path(hive)
    end
    column :nombre do |hive|
      hive.name
    end
    column :descripcion do |hive|
      hive.description
    end
    column :ultimo_promedio_de_temperatura do |hive|
      "#{hive.last_temperature_measure} - #{hive.last_temperature_measure_date}"
    end
    column :sensores_de_temperatura_funcionando do |hive|
      "#{hive.temperature_grid_working_positions&.count(true)}/#{hive.temperature_grid_working_positions&.count}"
    end
    column :balanza_calibrada do |hive|
      hive.scale_calibrated
    end
    column :ultimo_peso do |hive|
      "#{hive.last_weight_measure} - #{hive.last_weight_measure_date}"
    end
    column :puerta do |hive|
      "#{hive.door_status_to_s}"
    end
    column :ultimo_comando_a_puerta do |hive|
      hive.door_last_command_to_s
    end
  end

  show do
    attributes_table do
      row :uuid do |hive|
        link_to hive.uuid, admin_hive_path(hive)
      end
      row :nombre do |hive|
        hive.name
      end
      row :descripcion do |hive|
        hive.description
      end
      row :ultimo_promedio_de_temperatura do |hive|
        "#{hive.last_temperature_measure} - #{hive.last_temperature_measure_date}"
      end
      row :sensores_de_temperatura_funcionando do |hive|
        "#{hive.temperature_grid_working_positions&.count(true)}/#{hive.temperature_grid_working_positions&.count}"
      end
      row :balanza_calibrada do |hive|
        hive.scale_calibrated
      end
      row :ultimo_peso do |hive|
        "#{hive.last_weight_measure} - #{hive.last_weight_measure_date}"
      end
      row :puerta do |hive|
        "#{hive.door_status_to_s}"
      end
      row :ultimo_comando_a_puerta do |hive|
        hive.door_last_command_to_s
      end
    end

    panel'Puerta' do
      columns do
        column do
          div do
            link_to(
              'Cerrar puerta',
              close_door_admin_hive_path(hive),
              method: :post,
              data: { confirm: 'Seguro que quiere cerrar puerta?' }
            )
          end
        end
        column do
          div do
            link_to(
              'Abrir puerta',
              open_door_admin_hive_path(hive),
              method: :post,
              data: { confirm: 'Seguro que quiere abrir puerta?' }
            )
          end
        end
      end
    end

    if hive.scale
      panel 'Balanza' do
        render partial: 'hives/graph', locals: { data: hive.scale_graph_data }
        columns do
          column do
            div do
              render partial: 'hives/edit_scale_graph_points', locals: { hive: hive }
              render partial: 'hives/export_csv', locals: { hive: hive, class_name: 'weight' }
            end
          end
          column do
            div do
              render partial: 'hives/edit_tare', locals: { hive: hive }
            end
          end
          column do
            div do
              render partial: 'hives/edit_slope', locals: { hive: hive } if hive.scale.tare
            end
          end
        end
      end
    end

    panel 'Temperatura' do
      render partial: 'hives/export_csv', locals: { hive: hive, class_name: 'temperature' }
      div do
        render partial: 'hives/edit_temperature_grid_graph_points', locals: { hive: hive }
      end
      columns do
        (0..2).each do |index|
          column do
            data = hive.temperature_grid_graph_data
            sensors = hive.temperature_grid_working_positions
            attributes_table do
              row :existente do
                sensors[index] != nil
              end
              row :activo do
                sensors[index]
              end
            end
            render partial: 'hives/graph', locals: { data: hive.temperature_grid_graph_data[index] }
          end
        end
      end
      columns do
        (3..5).each do |index|
          column do
            data = hive.temperature_grid_graph_data
            sensors = hive.temperature_grid_working_positions
            attributes_table do
              row :existente do
                sensors[index] != nil
              end
              row :activo do
                sensors[index]
              end
            end
            render partial: 'hives/graph', locals: { data: hive.temperature_grid_graph_data[index] }
          end
        end
      end
      columns do
        (6..8).each do |index|
          column do
            data = hive.temperature_grid_graph_data
            sensors = hive.temperature_grid_working_positions
            attributes_table do
              row :existente do
                sensors[index] != nil
              end
              row :activo do
                sensors[index]
              end
            end
            render partial: 'hives/graph', locals: { data: hive.temperature_grid_graph_data[index] }
          end
        end
      end
    end
  end

  filter :apiary, collection: Proc.new { current_user.apiaries }

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end
    f.actions
  end
end