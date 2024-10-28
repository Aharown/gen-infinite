class CreateVotes < ActiveRecord::Migration[7.1]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :answer, null: false, foreign_key: true
      t.integer :vote_type
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
