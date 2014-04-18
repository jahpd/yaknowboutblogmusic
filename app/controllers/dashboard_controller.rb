class DashboardController < ApplicationController

  before_filter :list_all_posts, only: [:index]  

  def index
    
  end
  
end
