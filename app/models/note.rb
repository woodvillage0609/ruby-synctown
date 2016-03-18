class Note < ActiveRecord::Base


validates :title, presence:true
validates :content, presence:true
validates :user_id, presence:true
belongs_to :user
has_many :likes, dependent: :destroy
has_many :liking_users, through: :likes, source: :user
has_many :posts, dependent: :destroy

has_attached_file :photo, 
  :styles => { large: "800x800>", medium: "500x500>", thumb: "300x300>" },
  :url    => "/assets/arts/:id/:style/:basename.:extension", 
  :path   => "#{Rails.root}/public/assets/arts/:id/:style/:basename.:extension"

validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

scope :subscribed, ->(followers) { where user_id: followers }


end
