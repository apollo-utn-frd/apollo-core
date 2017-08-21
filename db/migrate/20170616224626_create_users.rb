# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :name
      t.string :lastname
      t.string :google_id
      t.string :gender
      t.text :image_url
      t.text :image_filename
      t.text :thumbnail_filename
      t.text :description, default: '', null: false
      t.boolean :confirmed, default: false, null: false
      t.datetime :confirmed_at
      t.jsonb :extra, null: false, default: '[]'

      t.timestamps
    end

    add_index :users, :username
    add_index :users, :email
  end
end
