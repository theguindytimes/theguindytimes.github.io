class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  letsrate_rateable 
 
  extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :title,
      [:title, :id],
    ]
  end
  acts_as_taggable 

end
