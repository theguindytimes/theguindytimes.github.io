class HomeController < ApplicationController

	def index
		@articles = Article.all
		@article = Article.new
		# render :text => articles.to_yaml 
	end

end
