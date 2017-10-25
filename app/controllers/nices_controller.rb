class NicesController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  def create
    @nice = current_user.nices.build(review_id: params[:nice][:review_id])
    @review = @nice.review
    @nice.save
    @review.number_of_nices += 1
    @review.save
    respond_with @review
  end

  def destroy
    @nice = Nice.find(params[:id])
    @review = @nice.review
    @nice.destroy
    @review.number_of_nices -= 1
    @review.save
    respond_with @review
  end
end
