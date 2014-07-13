class CreateFiles < ActiveRecord::Migration
  def change
    create_table :files do |t|

      t.timestamps
    end
  end
end
