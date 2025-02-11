class PagesController < ApplicationController
  def home
    @basic_plan = Plan.find_by(id: 1)
    @pro_plan = Plan.find_by(id: 2)
  end
end
