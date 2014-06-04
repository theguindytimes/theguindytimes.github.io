class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :article, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
