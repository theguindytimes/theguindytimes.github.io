class AddDownloadableToDownloads < ActiveRecord::Migration
  def self.up
    add_attachment :downloads, :downloadable
  end

  def self.down
    remove_attachment :downloads, :downloadable
  end
end
