class CreateMetaProperties < ActiveRecord::Migration
  def change
    create_table :meta_properties do |t|
      t.uuid :meta_template_id
      t.uuid :property_id
      t.string :value

      t.timestamps null: false
    end
  end
end
