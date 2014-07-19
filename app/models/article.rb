class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments

  extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

  searchkick word_start: [:title],autocomplete: [:title]

  def slug_candidates
    [
      :title,
      [:title, :id],
    ]
  end
  acts_as_taggable 
  acts_as_taggable_on :author

end
