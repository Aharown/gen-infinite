class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    unless table_exists?(:users)
      create_table :users do |t|
        t.string :name
        t.string :email
        # autres colonnes

        t.timestamps
      end
    end
  end
end
