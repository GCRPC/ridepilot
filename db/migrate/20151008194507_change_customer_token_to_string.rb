class ChangeCustomerTokenToString < ActiveRecord::Migration
  def change
    remove_column :customers, :token, :uuid, default: 'uuid_generate_v4()'
    add_column :customers, :token, :string
  end
end
