class CommentsController < ApplicationController

  def create
    comment = Comment.new(comment_params)
    # binding.pry
    if comment.valid?
      comment.save
      @article = Article.find(params[:article_id])                # >>>> この記述がないと非同期でNGとなる
      # @comments = @article.comments.order("created_at DESC")      # >>>> この記述がないと非同期でNGとなる
      @comments = @article.comments.page(params[:page]).order("created_at DESC")

      render :index

    else
      @error_comment = comment
      @user_prof = current_user
      @article = Article.find(params[:article_id])
      @comment = Comment.new
      # @comments = @article.comments.order("created_at DESC")
      @comments = @article.comments.page(params[:page]).order("created_at DESC")

      render "articles/show"
    end
  end


  def destroy
    @comment = Comment.find(params[:id])
    @article = @comment.article
    # binding.pry
    @comment.delete 
    # @comments = @article.comments.order("created_at DESC")
    @comments = @article.comments.page(params[:page]).order("created_at DESC")
    
    render :index
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id, article_id: params[:article_id])
  end
end
