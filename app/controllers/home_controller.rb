class HomeController < ApplicationController

	def index
		@articles = Article.all
		@article = Article.new
		tags = ActsAsTaggableOn::Tag.all
		@tags = []
		@numbers = {1 => 'first', 2 => 'second', 3 => 'third', 4 => 'fourth'} #Any better way of doing this ?
		tags.each do |t|
			articles = []
			Article.tagged_with(t).order("views").limit(4).each do |a|
				articles << a
			end
			@tags << {name: t.name, articles: articles}
		end
		# render :text => @tags.to_yaml 
	end

end
