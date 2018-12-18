# frozen_string_literal: true

class AddEnabledToUsers < ActiveRecord::Migration[5.2]
  safety_assured

  def change
    add_column :users, :enabled, :boolean, null: false, default: true
  end
end
