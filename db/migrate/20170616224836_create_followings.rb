# frozen_string_literal: true
class CreateFollowings < ActiveRecord::Migration[5.1]
  def change
    create_table :followings do |t|
      t.uuid :following_id, null: false
      t.uuid :follower_id, null: false

      t.timestamps
    end

    add_foreign_key :followings, :users, column: :following_id, on_delete: :cascade
    add_foreign_key :followings, :users, column: :follower_id, on_delete: :cascade
  end
end
