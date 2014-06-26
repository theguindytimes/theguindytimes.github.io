class HomeController < ApplicationController

	def index
		@articles = Article.all
		@article = Article.new
		tags = Article.tag_counts
		# tags = ActsAsTaggableOn::Tag.order('taggings_count').all
		@tags = []
		@numbers = {1 => 'first', 2 => 'second', 3 => 'third', 4 => 'fourth', 5 => 'fifth', 6 => 'sixth', 7 => 'seventh', 8 => 'eighth'} #Any better way of doing this ?
		tags.limit(7).each do |t|
			articles = []
			Article.tagged_with(t).order("views").limit(4).each do |a|
				articles << a
			end
			@tags << {name: t.name, articles: articles}
		end
		# render :text => tags1.to_json 
	end

end
