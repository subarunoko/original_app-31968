require 'rails_helper'

RSpec.describe Profile, type: :model do
  before do
    @profile = FactoryBot.build(:profile)
  end

  describe "プロフィール新規登録" do
    context "プロフィール登録がうまくいくとき" do
      it "language_id等が存在すれば登録できる" do
        expect(@profile).to be_valid
      end

      it "descriptionが空欄でも登録できる" do
        @profile.description = ""
        expect(@profile).to be_valid
      end

    end 
   
    context "プロフィール登録がうまくいかないとき" do
      it "language_idが未選択では登録できない" do
        @profile.language_id = 0
        @profile.valid?
        expect(@profile.errors[:language_id]).to include "が未選択です"
      end

      it "descriptionが251文字以上では登録できない" do
        @profile.description = SecureRandom.alphanumeric(251)
        @profile.valid?
        expect(@profile.errors[:description]).to include "が文字数の上限を超えてます"
      end

    end
  end
end
