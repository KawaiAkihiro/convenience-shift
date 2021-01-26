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
    @notices = @master.notices.all
  end

  def shift_onoff
    @master = Master.find(params[:id])
    if @master.shift_onoff == false
      @master.shift_onoff = true
    else
      @master.shift_onoff = false
    end
    @master.save
    redirect_to @master
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

  def login_form
    @master = Master.find(params[:id])
     if logged_in_staff?
      redirect_to current_staff
      flash[:success] = "現在　#{current_staff.staff_name}さん　としてログイン中です"
     end
  end

  def login
    @master = Master.find(params[:id])
    @staff  = @master.staffs.find_by(staff_number: params[:staffs_session][:staff_number])  
    if @staff && @staff.authenticate(params[:staffs_session][:password])
      log_in_staff(@staff)
      #params[:session][:remember_me] == '1' ? remember(staff): forget(staff)
      redirect_to perfect_shifts_path
    else
      flash.now[:danger] = "従業員番号もしくはパスワードが間違っています"
      render 'login_form'
    end
  end

  def logout
    log_out_staff if logged_in_staff?
    redirect_to root_url
  end

  private
    def master_params
      params.require(:master).permit(:store_name, :user_name, :password, :password_confirmation)
    end
end
