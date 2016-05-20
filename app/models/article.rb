class Article < ActiveRecord::Base
	has_many :comments, dependent: :destroy

	self.per_page = 12

end
