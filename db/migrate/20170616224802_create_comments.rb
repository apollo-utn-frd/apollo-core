# frozen_string_literal: true
class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.text :content, null: false

      t.uuid :user_id, null: false
      t.uuid :travel_id, null: false

      t.timestamps
    end

    add_foreign_key :comments, :users, on_delete: :cascade
    add_foreign_key :comments, :travels, on_delete: :cascade
  end
end
