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
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:title, :content, :object)
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
