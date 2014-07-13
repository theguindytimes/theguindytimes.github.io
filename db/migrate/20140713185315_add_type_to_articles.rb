class AddTypeToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :post_type, :string
  end
end
