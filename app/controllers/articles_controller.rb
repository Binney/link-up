class ArticlesController < ApplicationController

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      flash[:success] = "Article posted!"
      redirect_to @article
    else
      render @article
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def index
    @articles = Article.all.paginate(page: params[:page])
  end

  private

    def article_params
      params.require(:article).permit(:title, :content)
    end

end
