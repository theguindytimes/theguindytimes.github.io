class AddUserToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :contributor, :string
  end
end
