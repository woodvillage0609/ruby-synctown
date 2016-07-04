module UsersHelper

	def image_for(user)

		if user.image?
			image_tag(user.image, {class: "img-circle"})
		else
			image_tag("IMG_0121.jpg", {class: "img-circle"})
		end

	end

	def portrait(size)

    # Twitter
    # mini (24x24)                                                                  
    # normal (48x48)                                            
    # bigger (73x73)                                                
    # original (variable width x variable height)

end

end
