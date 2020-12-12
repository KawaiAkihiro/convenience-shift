class MastersController < ApplicationController

  def new
    @master = Master.new
  end

  def create
    @master = Master.new(master_params)
    if @master.save
      log_in @master
      flash[:success] = "ユーザー登録が完了しました！次はシフト時間帯の設定をしていきましょう！"
      redirect_to @master
      #最終的にはsettingページに飛ばしたい。
    else
      render 'new'
    end
  end

  def show
    @master = Master.find(params[:id])
  end

  def edit
    @master = Master.find(params[:id])
  end

  private
    def master_params
      params.require(:master).permit(:store_name, :user_name, :password, :password_confirmation)
    end
end
