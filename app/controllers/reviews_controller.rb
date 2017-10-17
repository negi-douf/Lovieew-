class ReviewsController < ApplicationController
  before_action :set_errors, only: [:new, :edit]

  # エラー出力用のグローバル変数
  # エラーメッセージを格納する
  $errors = []

  def index
    @reviews = Review.all
  end

  def new
    @review = Review.new
  end

  def create
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
    unless $errors.empty?
      @errors = $errors
      $errors = []
    end
  end
end
