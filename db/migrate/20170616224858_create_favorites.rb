# frozen_string_literal: true
class CreateFavorites < ActiveRecord::Migration[5.1]
  def change
    create_table :favorites do |t|
      t.uuid :user_id, null: false
      t.uuid :travel_id, null: false

      t.timestamps
    end

    add_foreign_key :favorites, :users, on_delete: :cascade
    add_foreign_key :favorites, :travels, on_delete: :cascade
  end
end
