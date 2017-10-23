class NicesController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  def create
    @nice = current_user.nices.build(review_id: params[:nice][:review_id])
    @review = @nice.review
    @nice.save
    respond_with @review
  end

  def destroy
    @nice = Nice.find(params[:id])
    @review = @nice.review
    @nice.destroy
    respond_with @review
  end
end
