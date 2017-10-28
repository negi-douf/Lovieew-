class CommentsController < ApplicationController
  before_action :set_instances, only: [:edit, :update, :destroy]

  def create
    @comment = current_user.comments.build(comments_params)
    @review = @comment.review
    # クライアント要求に応じてフォーマットを変更
    respond_to do |format|
      if @comment.save
        format.js { redirect_to review_path(@review), notice: 'コメントを投稿しました。' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    unless @comment.update(comments_params)
      flash.now[:danger] = "コメントの更新に失敗しました。"
    end
    redirect_to review_path(@review)
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to review_path(@review) }
        format.js { render :index }
      else
        format.html { render :new }
      end
    end
  end

  private

    def comments_params
      params.require(:comment).permit(:review_id, :content)
    end

    def set_instances
      @comment = Comment.find(params[:id])
      @review = @comment.review
    end
end
