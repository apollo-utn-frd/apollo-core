# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    create_table :notifications do |t|
      t.boolean :readed, default: false, null: false
      t.datetime :readed_at

      t.uuid :user_id, null: false
      t.uuid :event_id, null: false

      t.timestamps
    end

    add_foreign_key :notifications, :users, on_delete: :cascade
    add_foreign_key :notifications, :events, on_delete: :cascade
  end
end
