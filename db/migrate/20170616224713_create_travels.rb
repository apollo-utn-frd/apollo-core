# frozen_string_literal: true

class CreateTravels < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    create_table :travels do |t|
      t.string :title, null: false
      t.text :description, default: '', null: false
      t.text :picture_local_path
      t.boolean :publicx, default: true, null: false

      t.uuid :user_id, null: false

      t.timestamps
    end

    add_foreign_key :travels, :users, on_delete: :cascade
  end
end
