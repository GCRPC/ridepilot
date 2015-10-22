class CreateHiddenLookupTableValues < ActiveRecord::Migration
  def change
    create_table :hidden_lookup_table_values do |t|
      t.references :provider, index: true
      t.string :table_name
      t.integer :value_id

      t.timestamps
    end
  end
end
