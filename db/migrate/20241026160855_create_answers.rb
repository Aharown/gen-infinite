class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
