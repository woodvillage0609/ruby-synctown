class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

	validates :name, presence:true
	validates :email, uniqueness:true
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
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|

        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.name = auth.info.nickname
        user.name = auth.info.name

        if auth.info.image.present? && auth.provider == 'facebook'
          require 'open-uri'
          require 'open_uri_redirections'
          user.image = open(auth.info.image, :allow_redirections => :safe)

        elsif auth.info.image.present? && auth.provider == 'twitter'
          require 'open-uri'
          require 'open_uri_redirections'
          user.image = auth.info.image.sub("_normal", "")

        end

    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
      user.attributes = params
      user.valid?
      end
      else
      super 
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
