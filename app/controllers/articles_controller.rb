class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update, :destroy]
    before_action :check_user,  only: [:index, :new, :new_news, :edit]
    #caches_page :show
    # GET /articles
    # GET /articles.json
    def index
	@articlesfresh = Article.where(status: "Visible to Public", post_type: 'article').order('created_at DESC').paginate(:page => params[:page], :per_page => 5)
        if params[:tag]
            if params[:name].present?
                @articles = Article.search(params[:name], title: params[:name]).where(status: "Visible to Public").tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 2)
            else
                @articles = Article.where(status: "Visible to Public").tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 2)
            end
            if request.headers['X-PJAX'] or request.xhr?
                author = ActsAsTaggableOn::Tagging.where(:context => :author,:'tags.name' => params[:tag]).joins(:tag).select('DISTINCT tags.name').map{ |x| x.name}
                @tag_flag = params[:tag]
                @tag_user = author.length>0
                render :partial => 'home/articles'
            else
                redirect_to :controller => 'home', :action => 'index', :tag => params[:tag]
            end
        else
            if params[:name].present?
                @articles = Article.where(status: "Visible to Public").tagged_with(params[:tag]).search(params[:name], title: params[:name])#.paginate(:page => params[:page], :per_page => 2)
                redirect_to :controller => 'home', :action => 'index', :name => params[:name]
            else
                @articles = Article.all
            end
        end
    end

    def autocomplete
        render json: Article.search(params[:query], autocomplete: true, limit: 10).map(&:title)
    end

    # GET /articles/1
    # GET /articles/1.json
    def show
	expire_page :action => :index, :controller => :home
        article = Article.friendly.find(params[:id])
        if article.views == nil
            article.views = 0
        end
        article.views = article.views + 1
        article.save
        @article = Article.friendly.find(params[:id])
        if current_user and current_user.admin?
            @comments = @article.comments.all
        else
            @comments = @article.comments.where(:status => 'Approved')
        end
        if request.xhr?
            @xhr = true
        end
            
            @a = {'article' => article , 'tags' => article.tag_list, 'img' => article.first_pic,'comments' => @comments }
            # render :json => a
        if @xhr
            render :layout => false
        # else
        #     if !(current_user and current_user.admin?)
        #         redirect_to :controller => 'home', :action => 'index', :article => article.slug
        #     end
        end
    end

    # GET /articles/new
    def new
        @article = Article.new
        @type = 'article'
    end

    def new_news
        @article = Article.new
        @type = 'news'
        render 'articles/new'
    end

    # GET /articles/1/edit
    def edit
	expire_page :action => :show
	expire_page :action => :index, :controller => :home
    	@type = @article.post_type
	if @type.blank?
		@type='article'
	end
    end

    # POST /articles
    # POST /articles.json
    def create
        @article = Article.new(article_params)
        @article.user = current_user
        @article.views = 0
        respond_to do |format|
            if @article.save
                format.html { redirect_to @article, notice: 'Article was successfully created.' }
                format.json { render :show, status: :created, location: @article }
            else
                format.html { render :new }
                format.json { render json: @article.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /articles/1
    # PATCH/PUT /articles/1.json
    def update
	expire_page :action => :show
	expire_page :action => :index, :controller => :home
        respond_to do |format|
            if @article.update(article_params)
                format.html { redirect_to @article, notice: 'Article was successfully updated.' }
                format.json { render :show, status: :ok, location: @article }
            else
                format.html { render :edit }
                format.json { render json: @article.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /articles/1
    # DELETE /articles/1.json
    def destroy
        @article.destroy
        respond_to do |format|
            format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_article
        @article = Article.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
        params.require(:article).permit(:title, :content, :status,:tag_list, :author_list, :post_type)
    end
end
