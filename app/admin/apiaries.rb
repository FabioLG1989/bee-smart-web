ActiveAdmin.register Apiary do
  permit_params :description, :name
  menu label: 'Apiarios'

  actions :index, :show, :edit, :update

  controller do
    def scoped_collection
      current_user.apiaries
    end
  end

  member_action :unlink do
    apiary = Apiary.find(resource.id)
    current_user.apiaries.delete(apiary)
    redirect_to admin_apiaries_path
  end

  action_item :add, only: :index do
    link_to(
      I18n.t('active_admin.actions.add_apiary'),
      add_admin_apiaries_path,
      method: :get
    )
  end

  collection_action :add, method: :get do
    @apiary = Apiary.new

    respond_to do |f|
      f.html do
        render template: "apiaries/add"
      end
    end
  end

  collection_action :add_or_create, method: :post do
    current_user.apiaries << Apiary.find_or_create_by(uuid: params[:apiary][:uuid])
    current_user.save!
    redirect_to admin_apiaries_path
  end

  index do
    column :uuid do |apiary|
      link_to apiary.uuid, admin_apiary_path(apiary)
    end
    column :nombre do |apiary|
      apiary.name
    end
    column :descripcion do |apiary|
      apiary.description
    end
    column :ultima_actividad do |apiary|
      apiary.messages.last&.created_at&.to_s
    end
    column :colmenas do |apiary|
      apiary.hives.count
    end
    column nil do |apiary|
      link_to 'Desvincular', unlink_admin_apiary_path(apiary)
    end
  end

  show do
    attributes_table do
      row :uuid
      row :nombre do |apiary|
        apiary.name
      end
      row :descripcion do |apiary|
        apiary.description
      end
    end

    panel 'Colmenas' do
      table_for apiary.hives do
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
          hive.door_status_to_s
        end
        column :ultimo_comando_a_puerta do |hive|
          hive.door_last_command_to_s
        end
      end
    end
  end

  filter :uuid
  filter :name
  filter :description

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
    end
    f.actions
  end
end
