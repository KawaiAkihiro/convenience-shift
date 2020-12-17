class ShiftSeparationsController < ApplicationController
    def new
        @shift_separation = current_master.shift_separations.new
    end

    def create
        @shift_separation = current_master.shift_separations.new(separation_params)
        if @shift_separation.save
            flash[:success] = "シフトコマを作成完了しました！"
            redirect_to current_master
        else
            render 'new'
        end
    end

    private 
      def separation_params
        params.require(:shift_separation).permit(:name, :start_time, :finish_time)
      end
end
