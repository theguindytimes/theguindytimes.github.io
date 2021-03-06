class HomeController < ApplicationController

	# before_action :old_article_fix

    	#caches_page :index
	def trending
		articles = Article.where(status: "Visible to Public", post_type: 'article').order('created_at DESC').select("title","views","created_at","id").limit(20)
		views = articles.first.views;
		time =  (Time.now - articles.first.created_at)
		art = articles.to_a.map(&:serializable_hash).sort! {|a,b| a['views']/((Time.now-a['created_at'])/1.day) <=> b['views']/((Time.now-b['created_at'])/1.day)}.reverse
		articlesfresh = Article.where(status: "Visible to Public", post_type: 'article').order('created_at DESC').limit(5)
		nids=[]
		articlesfresh.each do |a|
			nids.append(a.id)
		end
		ids=[]
		(0..10).each do |i|
			ids.append(art[i]['id'])
		end
		ids = ids - nids
		@articles = Article.where(status: "Visible to Public",post_type: 'article').where("id IN (?)", ids)
		render :text => (views/(time/1.day)).to_s + @articles.to_json
		#render :text => avg_views.to_s + @articles.to_json.to_s
	end

	def index
        @message=Message.new
	@articlesfresh = Article.where(status: "Visible to Public", post_type: 'article').order('created_at DESC').paginate(:page => params[:page], :per_page => 5)
        if params[:tag]
            author = ActsAsTaggableOn::Tagging.where(:context => :author,:'tags.name' => params[:tag]).joins(:tag).select('DISTINCT tags.name').map{ |x| x.name}
        	@articles = Article.where(status: "Visible to Public", post_type: 'article').tagged_with(params[:tag]).order('views DESC').paginate(:page => params[:page], :per_page => 5)
        	@tag_flag = params[:tag]
        	@tag_user = author.length>0
		elsif params[:name]
        	@tag_flag = false
            @articles = Article.where(status: "Visible to Public", post_type: 'article').tagged_with(params[:tag]).search(params[:name], title: params[:name])#.paginate(:page => params[:page], :per_page => 2)
		else
        	@tag_flag = false
		#	@articles = Article.where(status: "Visible to Public", post_type: 'article').order('views DESC').paginate(:page => params[:page], :per_page => 5)
	

		articles = Article.where(status: "Visible to Public", post_type: 'article').order('created_at DESC').select("title","views","created_at","id").limit(20)
		views = articles.first.views;
		time =  (Time.now - articles.first.created_at)
		art = articles.to_a.map(&:serializable_hash).sort! {|a,b| a['views']/((Time.now-a['created_at'])/1.day) <=> b['views']/((Time.now-b['created_at'])/1.day)}.reverse
		articlesfresh = Article.where(status: "Visible to Public", post_type: 'article').order('created_at DESC').limit(5)
		nids=[]
		articlesfresh.each do |a|
			nids.append(a.id)
		end
		ids=[]
		(0..19).each do |i|
			ids.append(art[i]['id'])
		end
		ids = ids - nids
		@articles = Article.where(status: "Visible to Public",post_type: 'article').where("id IN (?)", ids).paginate(:page => params[:page], :per_page => 5)

	
		end
		if request.headers['X-PJAX'] or request.xhr?
			render :partial => 'home/articles'
			return
		end
		@events = Event.all
		@article = Article.new
		tags = Article.where(status: "Visible to Public", post_type: 'article').tag_counts.order('taggings_count DESC')
		require 'nokogiri'
		# tags = ActsAsTaggableOn::Tag.order('taggings_count').all
		@tags = []
		@images = []
		@numbers = {1 => 'first', 2 => 'second', 3 => 'third', 4 => 'fourth', 5 => 'fifth', 6 => 'sixth', 7 => 'seventh', 8 => 'eighth'} #Any better way of doing this ?
		tags.limit(7).each do |t|
			articles = []
			Article.tagged_with(t).order("views").where(status: "Visible to Public", post_type: 'article').limit(4).each do |a|
				doc = Nokogiri::HTML( a.content )
        		img_srcs = doc.css('img').map{ |i| i['src'] }
        		article={}
				article['title']=a.title
				article['slug']=a.slug
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
		@hotArticles = Article.where(status: "Visible to Public", post_type: 'article').order("views").limit(5)
		@hotNews = Article.where(status: "Visible to Public", post_type: 'news').order("views").limit(5)
		# render :text => @articles.to_yaml
	end

	def eEdition
		redirect_to 'http://issuu.com/guindytimes'
	end

	def admin
		redirect_to root_path if !(current_user and current_user.admin?)
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
