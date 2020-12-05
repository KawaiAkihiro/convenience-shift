require 'rails_helper'

RSpec.describe Master, type: :model do

  let(:master) {FactoryBot.build(:master)}

  it "店名と氏名があれば有効である" do
    
    expect(master).to be_valid
  end

  it "名前なしでは登録不可" do
    master.user_name = nil
    expect(master).to_not be_valid
  end

  it "店名なしでは登録不可" do
    master.store_name = nil
    expect(master).to_not be_valid
  end

  it "同じ店名は登録不可" do
    master.save
    master2 = FactoryBot.build(:master, store_name: master.store_name)
    expect(master2).to_not be_valid
  end

  it "長すぎる店名は登録不可" do
    master.store_name = "a"*21
    expect(master).to_not be_valid
  end

  it "長すぎる名前は登録不可" do
    master.user_name = "a"*21
    expect(master).to_not be_valid
  end

  it "パスワードなしは登録不可" do
    master.password = master.password_confirmation = " " * 6
    expect(master).to_not be_valid
  end

  it "パスワードは6文字以上でないといけない" do
    master.password = master.password_confirmation = "a" * 5
    expect(master).to_not be_valid
  end




end
