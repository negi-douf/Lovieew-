class NicesController < ApplicationController
  before_action :authenticate_user!
  respond_to :js

  def create
    @nice = current_user.nice.build(nice_params)
    @nice.save
  end

  def destroy
  end

  private

    def nice_params
      params.require(:nice).premit(:review_id)
    end
end
