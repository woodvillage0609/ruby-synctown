class ApplicationController < ActionController::Base
 
 before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper


class Entry 

	def initialize(image,title,content)
		@image = image
		@title = title
		@content = content
	end

	attr_reader :image, :title, :content
end

def scrape_article
	require 'open-uri'
	url = 'http://www.gizmodo.jp/2016/02/bikeinlondon.html'
    doc = Nokogiri::HTML(open(url))

    @articlesArray = []

	image = doc.css('.cXenseParse img').attribute('src')
	title = doc.title
	content = doc.css('.cXenseParse').text
	@articlesArray << Entry.new(image,title,content)

	render template: 'scrape_article'
end


private
def configure_permitted_parameters
	devise_parameter_sanitizer.for(:sign_up) << :name
end

end
