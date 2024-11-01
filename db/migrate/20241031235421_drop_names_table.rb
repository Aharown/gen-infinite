class DropNamesTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :names
  end
end
