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
      
      #店長用の従業員データを作成
      @staff = current_master.staffs.new
      @staff.staff_name = current_master.user_name
      @staff.staff_number = current_master.staff_number
      @staff.password = "0000"
      @staff.password_confirmation = "0000"
      @staff.save

      #空きシフトを作るための空従業員を作成
      @empty_staff = current_master.staffs.new
      @empty_staff.staff_name = "empty"
      @empty_staff.staff_number = 0
      @empty_staff.password = "0000"
      @empty_staff.password_confirmation = "0000"
      @empty_staff.save

      flash[:success] = "ユーザー登録が完了しました！"
      redirect_to root_path
    else
      render 'new'
    end
  end

  #シフトを募集開始と終了を判定
  def shift_onoff
    if !current_master.shift_onoff
      current_master.shift_onoff = true
    else
      current_master.shift_onoff = false
    end
    current_master.save
    redirect_to root_url
    if current_master.shift_onoff
      flash[:success] = "シフト募集を開始しました"
    else
      flash[:success] = "シフト募集を終了しました"
    end
    
  end

  def edit
    @master = Master.find(params[:id])
  end

  def update
    @master = Master.find(params[:id])
    if @master.update(master_params)
      flash[:success] = "プロフィールを変更しました"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  #従業員用ログインページ
  def login_form
    @master = Master.find(params[:id])
     if logged_in_staff?
      redirect_to root_url
      flash[:success] = "現在　#{current_staff.staff_name}さん　としてログイン中です"
     end
  end
  
  #従業員用ログイン処理
  def login
    @master = Master.find(params[:id])
    @staff  = @master.staffs.find_by(staff_number: params[:staffs_session][:staff_number])  
    if @staff && @staff.authenticate(params[:staffs_session][:password])
      log_in_staff(@staff)
      redirect_to root_path
    else
      flash[:danger] = "従業員番号もしくはパスワードが間違っています"
      render 'login_form'
    end
  end

  #従業員用ログアウト
  def logout
    log_out_staff if logged_in_staff?
    redirect_to root_url
  end

  private
    def master_params
      params.require(:master).permit(:store_name, :user_name, :staff_number, :email, :onoff_email, :password, :password_confirmation)
    end
end
