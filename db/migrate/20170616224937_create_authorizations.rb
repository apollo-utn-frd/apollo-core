# frozen_string_literal: true

class CreateAuthorizations < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    create_table :authorizations do |t|
      t.uuid :user_id, null: false
      t.uuid :travel_id, null: false

      t.timestamps
    end

    add_foreign_key :authorizations, :users, on_delete: :cascade
    add_foreign_key :authorizations, :travels, on_delete: :cascade
  end
end
