# frozen_string_literal: true

class CreatePlaces < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    create_table :places do |t|
      t.st_point :lonlat, geographic: true
      t.string :title, default: '', null: false
      t.text :description, default: '', null: false

      t.uuid :travel_id, null: false

      t.timestamps
    end

    add_foreign_key :places, :travels, on_delete: :cascade
  end
end
