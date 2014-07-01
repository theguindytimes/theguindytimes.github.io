class HomeController < ApplicationController

	def index
		@articles = Article.all
		@article = Article.new
		tags = Article.tag_counts.order('taggings_count DESC')
		require 'nokogiri'
        
		# tags = ActsAsTaggableOn::Tag.order('taggings_count').all
		@tags = []
		@images = []
		@numbers = {1 => 'first', 2 => 'second', 3 => 'third', 4 => 'fourth', 5 => 'fifth', 6 => 'sixth', 7 => 'seventh', 8 => 'eighth'} #Any better way of doing this ?
		tags.limit(7).each do |t|
			articles = []
			Article.tagged_with(t).order("views").limit(4).each do |a|
				doc = Nokogiri::HTML( a.content )
        		img_srcs = doc.css('img').map{ |i| i['src'] }
        		article={}
				article['title']=a.title
				article['content']=a.content[0,400]
				if img_srcs.length>0
					article['img']=img_srcs[0]
					@images << {'src' => img_srcs,'article'=> a} unless @images.include?({'src' => img_srcs,'article'=> a})
				else
					article['img']='default_article.jpg'
				end
        		# article.update(a) 
				# a['img'] = img_srcs
				# a.content[0,400]
				articles << article
			end
			@tags << {name: t.name, articles: articles}
		end
		# @images = Ckeditor::Picture.all.pluck('id','data_file_name')
		# render :text => @images.to_yaml
		@hotArticles = Article.order("views").limit(5)
	end

end
