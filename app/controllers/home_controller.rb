class HomeController < ApplicationController

	def index
		@articles = Article.all
		# render :text => articles.to_yaml 
	end

end
