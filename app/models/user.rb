class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

	validates :name, presence:true
	validates :email, presence:true, uniqueness:true
	has_many :notes
  has_many :likes
  has_many :like_notes, through: :likes, source: :note
  has_many :posts
  has_many :post_notes, through: :posts, source: :note
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :subscribed, class_name: "Relationship", foreign_key: "followed_id" 

  has_many :comments
  has_many :comment_articles, through: :comments, source: :article

  has_many :opinions
  has_many :opinion_microposts, through: :opinions, source: :micropost

  has_attached_file :image
  validates_attachment :image, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

# ユーザーをフォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # ユーザーをアンフォローする
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def admin?
    admin
  end

  #Facebookでログイン
  validates :password, presence: false, on: :facebook_login

    def self.from_omniauth(auth)
        # emailの提供は必須とする
        user = User.where('email = ?', auth.info.email).first
      if user.blank?
        user = User.new
      end
    user.uid   = auth.uid
    user.name  = auth.info.name
    user.email = auth.info.email
    user.icon  = auth.info.image
    user.oauth_token      = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user
    end

end
