# frozen_string_literal: true
class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :type, null: false

      t.timestamps
    end

    add_reference :events, :source, polymorphic: true, null: false
    add_reference :events, :resource, polymorphic: true, null: false
  end
end
