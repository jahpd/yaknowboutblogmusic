class VisitorsController < ApplicationController

  before_filter :all_posts_from_all_users, only: [:index]

  def index
    @info = [
      {:src => "http://rubyonrails.org/", :msg => "Rails v. #{Rails::VERSION::STRING}" }, 
      {:src => "https://www.ruby-lang.org", :msg => "Ruby v. #{RUBY_VERSION}" }, 
      {:src => "https://railsapps.github.io/", :msg =>"RailsApp" }    
    ]
  end

end
