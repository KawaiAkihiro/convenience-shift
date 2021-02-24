require 'rails_helper'

RSpec.describe IndividualShift, type: :model do
  describe "単一データによる有効性" do
    let!(:master) { create(:master_staff) }
    let!(:staff)  { create(:staff, master_id: master.id) }
    let(:shift)   { staff.individual_shifts.build(start: "2020-01-01 12:00", 
                                                  finish: "2020-01-01 18:00", 
                                                  confirm: false, Temporary: false) }

    example "有効なデータ" do
      # expect(shift).to be_valid
    end

    example "出勤時間が空白は無効になる" do
      # shift.start = ""
      # expect(shift).to be_invalid
    end

    example "退勤時間が空白は無効になる" do
      # shift.finish = ""
      # expect(shift).to be_invalid
    end

    example "出勤時間 > 退勤時間は無効" do
      # shift.finish = "2020-01-01 09:00:00"
      # expect(shift).to be_invalid
    end

    example "shiftの親孫関係" do
      # expect(shift.staff).to eq staff
      # expect(staff.master).to eq master
      # expect(shift.master).to eq master
      # shift.save
      # expect(master.individual_shifts.first).to eq shift
    end
  end

  describe "複数データの並び順テスト" do
    # let!(:master) { create(:master_staff) }
    # let!(:staff)  { create(:staff, master_id: master.id) }  
    # let!(:shift1) { create(:shift1, staff_id: staff.id) }
    # let!(:shift2) { create(:shift2, staff_id: staff.id) }
    # let!(:staff2) { create(:leader, master_id: master.id) }
    # let!(:shift3) { create(:shift3, staff_id: staff2.id) }

    example "違うユーザが混ざっていても並び順の基準はstartに依存する" do
      # expect(IndividualShift.first).to eq shift3
      # expect(IndividualShift.second).to eq shift1
      # expect(IndividualShift.third).to eq shift2
    end
  end
end
