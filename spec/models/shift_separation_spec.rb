require 'rails_helper'

RSpec.describe ShiftSeparation, type: :model do
  describe "1つデータのバリデーションテスト" do
    let!(:master) { create(:master) }
    let!(:shift)  { master.shift_separations.build(name: "シフト",
                                                   start_time: "2000-01-01 07:00:00",
                                                   finish_time: "2000-01-01 10:00:00" )}

    example "初期設定は有効" do
      expect(shift).to be_valid
    end

    example "nameは必要" do
      shift.name = nil
      expect(shift).to_not be_valid
    end

    example "start_timeは必要" do
       shift.start_time = nil
       expect(shift).to_not be_valid
    end

    example "finish_timeは必要" do
      shift.finish_time = nil
      expect(shift).to_not be_valid
    end

    example "通常時間はstart_time < finish_timeを厳守する" do
      shift.finish_time = "2000-01-01 05:00:00"
      expect(shift).to_not be_valid
      expect(shift.errors.full_messages).to include "終了時刻が開始時刻を上回っています。正しく記入してください。"
    end

    example "夜勤帯は上記制限を解除する" do
      shift.start_time = "2000-01-01 22:00:00"
      shift.finish_time = "2000-01-01 7:00:00"
      expect(shift).to be_valid
    end
  end


  describe "名前の一意性確認テスト" do
    let!(:master) { create(:master) }
    let!(:morning_fast) { create(:morning_fast, master_id: master.id) }
    let!(:new_shift) { master.shift_separations.build(name: morning_fast.name,
                                               start_time: morning_fast.start_time, 
                                              finish_time: morning_fast.finish_time)}
    example "同じ名前は登録できない" do
      expect(new_shift).to_not be_valid
      expect(new_shift.errors.full_messages).to include "時間帯名はすでに存在します"
    end
  end

  describe "2つ以上のデータの並び順テスト" do
    let!(:master) { create(:master) }
    let!(:morning_fast) { create(:morning_fast,master_id: master.id) }
    let!(:morning) { create(:morning_middle, master_id: master.id) }

    example "データはstart_timeが早い順に並ぶ" do
      expect(ShiftSeparation.first).to eq morning_fast
    end
  end
end
