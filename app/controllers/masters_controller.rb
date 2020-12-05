class MastersController < ApplicationController
  def new
    @master = Master.new
  end
end
