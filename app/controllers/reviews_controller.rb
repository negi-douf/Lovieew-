class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  def index
    @reviews = Review.order(created_at: :desc).page(params[:page])#.sort.reverse
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      flash.now[:success] = "レビューを投稿しました！"
      redirect_to reviews_path
      # レコードの中に見つかったタグのパラメータを
      # 消しているため、別処理で保存する
      unless @exist_tags.blank?
        # 重複した要素は消す
        @exist_tags.uniq!
        @exist_tags.each do |tag|
          @category = Category.create!(review_id: @review.id, tag_id: Tag.find_by(content: tag).id)
        end
        @exist_tags = []
      end
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
    @reviews = Review.order(number_of_nices: :desc).page(params[:page])
  end

  def search
    if params[:keyword]
      @keyword = String.new(params[:keyword])
    else
      @keyword = ""
    end
    keywords = @keyword.split(" ")
    # 検索し、いいねが多い順にソートする
    keywords.each do |word|
      @reviews = Review.search(:title_or_content_or_object_cont => word).result.order(number_of_nices: :desc).page(params[:page])
    end
  end

  private

    def review_params
      # params 編集用
      tmp_params = params
      # params を判定して必要に応じて修正
      if params[:review][:tags_attributes]
        tags_list = [tmp_params[:review][:tags_attributes][:"0"][:content]]
        count = 0
        first = 0
        # 存在しない値にアクセスするとエラーとなるため、
        # rescue で break する
        begin
          # params にアクセスできる間ループする
          while content = tmp_params[:review][:tags_attributes][:"#{count}"][:content] do
            # tags_list をイテレート、比較して値をユニークに。
            tags_list.each do |tag|
              # 11個目以降の場合、
              # params 内に同じデータがあれば場合、
              # レコード内に既に同一のタグが存在する場合はパラメータを削除
              if count == first
                if Tag.find_by(content: content)
                  @exist_tags.append(tmp_params[:review][:tags_attributes][:"#{count}"][:content])
                  tmp_params[:review][:tags_attributes].delete("#{first}")
                  first += 1
                  tags_list = [tmp_params[:review][:tags_attributes][:"#{first}"][:content]]
                end
              elsif tags_list.count > 9 || content == tag
                tmp_params[:review][:tags_attributes].delete("#{count}")
                break
              elsif Tag.find_by(content: content)
                @exist_tags.append(tmp_params[:review][:tags_attributes][:"#{count}"][:content])
                tmp_params[:review][:tags_attributes].delete("#{count}")
                break
              elsif tag == tags_list.last
                tags_list.append(tmp_params[:review][:tags_attributes][:"#{count}"][:content])
                break
              end
            end
            count += 1
          end
        rescue
        end
      end
      tmp_params.require(:review).permit(:title, :content, :object, :picture, :picture_cache,
        tags_attributes: [:content] )
    end

    def set_review
      @review = Review.find_by(id: params[:id])
    end

    def initialize
      # すでに存在していたタグを記憶し
      # 別で紐付ける
      @exist_tags = []
      super
    end

    def search_params
      pry.binding
      params.require(:keyword)
    end

end
