# frozen_string_literal: true
class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :latitude, null: false
      t.string :longitude, null: false
      t.string :title, default: '', null: false
      t.text :description, default: '', null: false

      t.uuid :travel_id, null: false

      t.timestamps
    end

    add_foreign_key :places, :travels, on_delete: :cascade
  end
end
