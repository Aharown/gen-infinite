class AddUsernameProfilePhotoUsertypeBioIntroReputationColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :profile_photo, :string
    add_column :users, :user_type, :string
    add_column :users, :bio, :text
    add_column :users, :intro, :text
    add_column :users, :reptutation, :integer
  end
end
