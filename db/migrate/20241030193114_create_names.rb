class CreateNames < ActiveRecord::Migration[7.1]
  def change
    create_table :names do |t|

      t.timestamps
    end
  end
end
