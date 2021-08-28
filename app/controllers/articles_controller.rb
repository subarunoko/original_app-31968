class ArticlesController < ApplicationController
  before_action :set_profile, except: [:create, :create_done, :destroy, :edit, :update]
  before_action :set_article, only: [:edit, :update, :show, :destroy, :destroy_caution]
  before_action :authenticate_user!, except: [:index ,:show, :show_article, :search]
  before_action :contributor_confirmation, only: [:edit, :update, :destroy, :destroy_caution]

  def index
    # @articles = Article.includes(:user).order("created_at DESC")
    @articles = Article.includes(:user).page(params[:page]).order("created_at DESC")
    # @articles = Article.page(params[:page]).per(8).order("created_at DESC")
  end

  def new
    # @article = Article.new
    @article = ArticleTag.new
  end

  def create
    # @article = Article.new(article_params)
    # binding.pry
    @article = ArticleTag.new(create_params)
    if @article.valid?
      @article.save
      redirect_to action: :create_done     # "保存成功" 完了ページへ戻る
    else
      render :new
    end

  end

  def create_done
    # @item = Article.order(updated_at: :desc).limit(1)       #最新のレコード1件取得
    # @item = @item[0]
  end

  def destroy
    if @article.destroy
      redirect_to action: :destroy_done # "削除成功" 完了ページへ戻る
    else
      render :destroy
    end
  end

  def destroy_caution
  end

  def destroy_done
  end

  def edit
    @tag_list = @article.tags.pluck(:name).join(" ")
    @form = ArticleTag.new(title: @article.title, body: @article.body, tag_ids: @tag_list)
  end

  def update
    current_tags = @article.tags.pluck(:name)
    @form = ArticleTag.new(update_params)
    if @form.valid?
      @form.update(current_tags)
      redirect_to action: :update_done     # "保存成功" 完了ページへ戻る
    else
      render :edit
    end
  end

  def update_done
  end

  def show
    @comment = Comment.new
    # @comments = @article.comments.order("created_at DESC")
    @comments = @article.comments.page(params[:page]).order("created_at DESC")
    # binding.pry
  end

  def show_article
    @articles = Article.where(user_id: params[:id])
    # @articles = @articles.order("created_at DESC")
    @articles = @articles.page(params[:page]).order("created_at DESC")
  end

  def search
    # @articles = Article.search(params[:keyword])                      #キーワード検索
    @articles = Article.search(params[:keyword]).page(params[:page])
  end

  def tag_search
    @tag = Tag.find(params[:tag_id])
    @articles = @tag.articles.all
    # @articles = @articles.order("created_at DESC")
    @articles = @articles.page(params[:page]).order("created_at DESC")
  end


  def attach
    attachment = Attachment.create! image: params[:image]
    render json: { filename: url_for(attachment.image) }
  end



  private

  def set_profile
    @user_prof = current_user
  end

  def set_article
    @article = Article.find(params[:id])
    # @user = User.find(params[:id])
    # @profile = @user.profile
  end

  def create_params
    # binding.pry
    # params.require(:article).permit(:title, :body).merge(user_id: current_user.id)
    params.require(:article_tag).permit(:title, :body, :name, :tag_ids).merge(user_id: current_user.id)
  end

  def update_params
    params.require(:article_tag).permit(:title, :body, :name, :tag_ids).merge(user_id: current_user.id, article_id: params[:id])
  end

  def contributor_confirmation
    if current_user != @article.user
      redirect_to root_path and return
    end
  end

end
