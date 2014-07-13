class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.datetime :from
      t.datetime :to
      t.time :timings
      t.text :description

      t.timestamps
    end
  end
end
