class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  searchkick word_start: [:name],autocomplete: [:name]

  has_many :articles
  has_many :comments

  def set_default_role
    if user.count == 1
      self.role ||= :admin
    else
      self.role ||= :user
    end
  end

  extend FriendlyId
    friendly_id :slug_candidates, use: :slugged

  def slug_candidates
    [
      :name,
      [:name, :id],
    ]
  end

  has_many :authentications

  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    self.name = omniauth.info.name if name.blank?
    self.date_of_birth = omniauth.extra.raw_info.birthday
    #self.password = '12345678' if name.password?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  has_attached_file :avatar, :styles => { :large => "500x500" , :medium => "300x300", :thumb => "100x100#" }, :default_url => "default_avatar.png"
    validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/jpg', 'image/png']   

end
