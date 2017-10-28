class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    @reviews = Review.all.sort.reverse
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      # tag を順に作っていく（最大10個）
      # ブランクの場合もあるため判定していく
      tags_count = 0
      count = 0
      # tag の数が限度以内であることをチェック
      while tags_count < 10 do
        # params が存在しなかった場合のためにエラー処理
        begin
          unless review_params[:tags_attributes][:"#{count}"][:content].blank?
            # 同じ内容の tag が見つかった場合は保存しない
            @exist_tag = Tag.find_by(content: review_params[:tags_attributes][:"#{count}"][:content])
            unless @exist_tag
              @tag = Tag.new(content: review_params[:tags_attributes][:"#{count}"][:content])
              @tag.save
              Category.create!(review_id: @review.id, tag_id: @tag.id)
              tags_count += 1
            else
              @category = Category.create!(review_id: @review.id, tag_id: @exist_tag.id)
            end
          end
          count += 1
        rescue
          break
        end
      end
      flash.now[:success] = "レビューを投稿しました！"
      redirect_to reviews_path
    else
      flash.now[:danger] = "レビューの投稿に失敗しました。"
      render "new"
    end
  end

  def show
    @comment = @review.comments.build
    @comments = @review.comments
  end

  def edit
  end

  def update
    if @review.update(review_params)
      flash.now[:success] = "レビューを更新しました！"
      redirect_to root_path
    else
      flash.now[:danger] = "レビューの更新に失敗しました。"
      redirect_to edit_review_path(@review.id)
    end
  end

  def destroy
    if @review.destroy
      flash.now[:success] = "レビューを削除しました。"
      redirect_to root_path
    else
      flash.now[:danger] = "レビューの削除に失敗しました。"
      redirect_to review_path(@review.id)
    end
  end

  def ranking
    @reviews = Review.order(number_of_nices: :desc)
  end

  private

    def review_params
      params.require(:review).permit(:title, :content, :object, :picture, :picture_cache,
        tags_attributes: [:content] )
    end

    def set_review
      @review = Review.find_by(id: params[:id])
    end
end
