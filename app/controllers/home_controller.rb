class HomeController < ApplicationController

  layout lambda { |controller| current_user.try(:role) == 'admin' ? 'admin' : 'application' }

  before_filter :authenticate_user!, :except => :index

  def index
    @news = News.all.limit(3).order('created_at desc')

  end

end
