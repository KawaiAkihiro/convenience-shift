class SessionsController < ApplicationController
  def new
  end

  def create
    master = Master.find_by(email: params[:session][:store_name])
    if master && master.authenticate(params[:session][:password])

    else
      flash.now[:danger] = '店舗名,またはパスワードが間違っています。'
      render 'new'
    end
  end
end
