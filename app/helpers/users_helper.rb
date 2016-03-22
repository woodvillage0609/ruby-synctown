module UsersHelper

def image_for(user)
	
	if user.image
		image_tag "/user_images/#{user.image}", class: "img-circle"
	else 
		image_tag "IMG_0058.jpg"
	end
    end

end
