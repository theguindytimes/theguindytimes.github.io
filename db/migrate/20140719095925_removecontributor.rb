class Removecontributor < ActiveRecord::Migration
  def change
      remove_column :articles,:contributor
  end
end
