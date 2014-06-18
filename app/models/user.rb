class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?
  letsrate_rater
  has_many :articles
  has_many :comments
  
  def set_default_role
    self.role ||= :admin
  end

  extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, :id],
    ]
  end

end
