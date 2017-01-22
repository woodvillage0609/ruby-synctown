module UsersHelper

	def image_for(user)

		if user.image?
			image_tag(user.image.url(:thumb), {class: "img-circle"})
		else
			image_tag("IMG_0121.jpg", {class: "img-circle"})
		end

	end

end
