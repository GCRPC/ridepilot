class CreateLiteCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :lite_customers do |t|
      t.string :first_name
      t.string :last_name
      t.boolean :senior
      t.boolean :disabled

      t.timestamps
    end
  end
end
