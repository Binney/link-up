class ArticlesController < ApplicationController
  before_filter :not_a_student, only: [:new, :create, :destroy]

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

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update_attributes(article_params)
    redirect_to @article
  end

  def index
    @articles = Article.all.paginate(page: params[:page])
  end

  def destroy
    @article = Article.find(params[:id])
    current_user.articles.find_by(id: @article.id).destroy
    redirect_to news_path
  end

  private

    def article_params
      params.require(:article).permit(:title, :content)
    end

    def not_a_student
      redirect_to root_path if current_user.role=="student"
    end

end
