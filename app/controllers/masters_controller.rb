class MastersController < ApplicationController

  before_action :logged_in_master, only: [:show, :edit, :update]
  before_action :corrent_master, only: [:show, :edit, :update]

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
    @shift_separations = current_master.shift_separations.all
  end

  def edit
    @master = Master.find(params[:id])
  end

  def update
    @master = Master.find(params[:id])
    if @master.update(master_params)
      flash[:success] = "プロフィールを変更しました"
      redirect_to @master
    else
      render 'edit'
    end
  end

  private
    def master_params
      params.require(:master).permit(:store_name, :user_name, :password, :password_confirmation)
    end

    def logged_in_master
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end

    def corrent_master
      @master = Master.find(params[:id])
      redirect_to(root_url) unless current_master?(@master)
    end 
end
