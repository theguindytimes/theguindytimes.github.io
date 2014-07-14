class Download < ActiveRecord::Base
  has_attached_file :downloadable, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :downloadable, :content_type =>['application/pdf', 'application/xlsx','image/jpeg','image/png','application/docx'],:message => ', Only pdf, xlsx, docx, jpg or png files are allowed.'
end
