# frozen_string_literal: true

class AddTokenAuthToUsers < ActiveRecord::Migration[5.1]
  safety_assured

  def change
    add_column :users, :uid, :text
    add_column :users, :provider, :string
    add_column :users, :oauth_token, :text
    add_column :users, :oauth_refresh_token, :text
    add_column :users, :oauth_expires_at, :datetime
    add_column :users, :tokens, :json

    add_index :users, :uid, unique: true
    add_index :users, %i[google_id provider], unique: true
  end
end
