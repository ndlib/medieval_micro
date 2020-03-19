class RenameModelNameToModelClassName < ActiveRecord::Migration
  def change
    rename_column :default_attribute_types, :model_name, :model_class_name
  end
end
