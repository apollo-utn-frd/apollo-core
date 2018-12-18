# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    add_column :users, :role, :string
    User.update_all(role: :regular)
    change_column_null :users, :role, false
  end
end
