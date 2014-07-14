class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string :title
      t.string :category
      t.text :description
      t.date :edition

      t.timestamps
    end
  end
end
