class AddUserIdToNames < ActiveRecord::Migration[7.1]
  def change
    add_reference :names, :user, null: false, foreign_key: true
  end
end
