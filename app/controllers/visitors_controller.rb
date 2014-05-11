class VisitorsController < ApplicationController

  before_filter :all_posts_from_all_users, only: [:index]

  def index
    
  end

end
