class HomeController < ApplicationController

	before_action :old_article_fix

	def index
        @message=Message.new
        if params[:tag]
        	@articles = Article.where(status: "Visible to Public").tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 2)
		elsif params[:name]
            @articles = Article.where(status: "Visible to Public").tagged_with(params[:tag]).search(params[:name], title: params[:name])#.paginate(:page => params[:page], :per_page => 2)
		else
			@articles = Article.where(status: "Visible to Public").paginate(:page => params[:page], :per_page => 2)
		end
		if request.headers['X-PJAX'] or request.xhr?
			render :partial => 'home/articles'
			return
		end
		@events = Event.all
		@article = Article.new
		tags = Article.where(status: "Visible to Public").tag_counts.order('taggings_count DESC')
		require 'nokogiri'
		# tags = ActsAsTaggableOn::Tag.order('taggings_count').all
		@tags = []
		@images = []
		@numbers = {1 => 'first', 2 => 'second', 3 => 'third', 4 => 'fourth', 5 => 'fifth', 6 => 'sixth', 7 => 'seventh', 8 => 'eighth'} #Any better way of doing this ?
		tags.limit(7).each do |t|
			articles = []
			Article.tagged_with(t).order("views").where(status: "Visible to Public").limit(4).each do |a|
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
			@tags << {tag: t, articles: articles}
		end
		# @images = Ckeditor::Picture.all.pluck('id','data_file_name')
		@hotArticles = Article.where(status: "Visible to Public").order("views").limit(5)
		# render :text => @articles.to_yaml
	end

	def admin
	end

	private

	def old_article_fix
		Article.all.each do |a|
			if not (a.status == 'Visible to Public' or a.status == 'Draft/Preview')
				a.status = 'Visible to Public'
				a.save
			end
		end
	end

end
