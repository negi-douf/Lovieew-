class NicesController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  def create
    @nice = current_user.nices.build(nice_params)
    @review = @nice.review
    @nice.save
    respond_with @review
  end

  def destroy
    @nice = Nice.find(nice_params(:id))
    @review = @nice.review
    @nice.destroy
    respond_with @review
  end

  private

    def nice_params
      params.require(:nice).permit(:review_id)
    end
end
