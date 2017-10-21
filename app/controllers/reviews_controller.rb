class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # エラー出力用のグローバル変数
  # エラーメッセージを格納する
  $errors = []

  def index
    @reviews = Review.all.sort.reverse
  end

  def new
    @review = Review.new
    get_errors
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      flash[:success] = "レビューを投稿しました！"
      redirect_to reviews_path
    else
      flash[:danger] = "レビューの投稿に失敗しました。"
      set_errors
      redirect_to new_review_path
    end
  end

  def show
    @comment = @review.comments.build
    @comments = @review.comments
  end

  def edit
    get_errors
  end

  def update
    if @review.update(review_params)
      flash[:success] = "レビューを更新しました！"
      redirect_to root_path
    else
      flash[:danger] = "レビューの更新に失敗しました。"
      set_errors
      redirect_to edit_review_path(@review.id)
    end
  end

  def destroy
    if @review.destroy
      flash[:success] = "レビューを削除しました。"
      redirect_to root_path
    else
      flash[:danger] = "レビューの削除に失敗しました。"
      set_errors
      redirect_to review_path(@review.id)
    end
  end

  private

    def review_params
      params.require(:review).permit(:title, :content, :object, :picture, :picture_cache)
    end

    def set_errors
      if @review.invalid?
        $errors = @review.errors.full_messages
      end
    end

    def get_errors
      @errors = $errors
      $errors = []
    end

    def set_review
      @review = Review.find_by(id: params[:id])
    end
end
