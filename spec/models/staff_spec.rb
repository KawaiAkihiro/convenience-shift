require 'rails_helper'

RSpec.describe Staff, type: :model do
  describe "1つのデータに対しての有効性テスト" do
      let!(:master) {FactoryBot.create(:master)}
      let(:staff)  {master.staffs.build(staff_name: "kawai", staff_number: 145, training_mode: false)}

    example "初期設定したstaffは有効" do
      expect(staff).to be_valid
    end

    example "master_idは必要である" do
      staff.master_id = nil
      expect(staff).to_not be_valid
    end

    example "staff_nameは必要である" do
      staff.staff_name  = nil
      expect(staff).to_not be_valid
    end

    example "staff_numberも必要である" do
      staff.staff_number = nil
      expect(staff).to_not be_valid
    end
  end

  describe "複数のデータに対しての有効性テスト" do
    let!(:master) { FactoryBot.create(:master) }
    let!(:staff)  { FactoryBot.create(:staff, master_id: master.id) }
    let!(:leader) { FactoryBot.create(:leader,master_id: master.id)}
    let!(:manager){ FactoryBot.create(:manager,master_id: master.id) }

    example "並び順は基本的に新しく登録した従業員が一番上に来る。" do
      expect(Staff.first).to eq manager
    end
  end
end
