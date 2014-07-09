class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :user_name
      t.text :body
      t.string :status
      t.references :article, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
