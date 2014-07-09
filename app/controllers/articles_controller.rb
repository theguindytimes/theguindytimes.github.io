class ArticlesController < ApplicationController
    before_action :set_article, only: [:show, :edit, :update, :destroy]

    # GET /articles
    # GET /articles.json
    def index
        if params[:tag]
            @articles = Article.tagged_with(params[:tag])
        else
            @articles = Article.all
        end
    end

    # GET /articles/1
    # GET /articles/1.json
    def show
        article = Article.friendly.find(params[:id])
        if article.views == nil
            article.views = 0
        end
        article.views = article.views + 1
        article.save
        @article = Article.friendly.find(params[:id])
        @comments = @article.comments.all
        if request.xhr?
            @xhr = true
        end
            require 'nokogiri'
            doc = Nokogiri::HTML( article.content )
            img_srcs = doc.css('img').map{ |i| i['src'] }
            if img_srcs.length > 0
                article.content[img_srcs[0]]=""
                img_tags = article.content.scan(/img.*style=".*"/)
                article.content[img_tags[0]] = "" if img_tags.length > 0
            else
                img_srcs=['']
            end
            @a = {'article' => article , 'tags' => article.tag_list, 'img' => img_srcs[0],'comments' => @comments }
            # render :json => a
        if @xhr
            render :layout => false
        end
    end

    # GET /articles/new
    def new
        @article = Article.new
    end

    # GET /articles/1/edit
    def edit
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
        params.require(:article).permit(:title, :content, :status,:tag_list,:contributor)
    end
end
