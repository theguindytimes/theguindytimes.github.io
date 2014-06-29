class HomeController < ApplicationController

	def index
		@articles = Article.all
		@article = Article.new
		tags = Article.tag_counts
		require 'nokogiri'
        
		# tags = ActsAsTaggableOn::Tag.order('taggings_count').all
		@tags = []
		@numbers = {1 => 'first', 2 => 'second', 3 => 'third', 4 => 'fourth', 5 => 'fifth', 6 => 'sixth', 7 => 'seventh', 8 => 'eighth'} #Any better way of doing this ?
		tags.limit(7).each do |t|
			articles = []
			Article.tagged_with(t).order("views").limit(4).each do |a|
				doc = Nokogiri::HTML( a.content )
        		img_srcs = doc.css('img').map{ |i| i['src'] }
        		article={}
				article['title']=a.title
				article['content']=a.content
				article['img']=img_srcs
        		# article.update(a) 
				# a['img'] = img_srcs
				# a.content[0,400]
				articles << a
			end
			@tags << {name: t.name, articles: articles}
		end
		# render :text => @tags.to_json 
	end

end
