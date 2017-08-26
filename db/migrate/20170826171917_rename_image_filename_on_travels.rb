# frozen_string_literal: true

class RenameImageFilenameOnTravels < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    change_table :travels do |t|
      t.rename :image_filename, :image_public_url
      t.rename :thumbnail_filename, :thumbnail_public_url
    end
  end
end
