require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe "ユーザー新規登録" do
    context "新規登録がうまくいくとき" do
      it "nicknameなどが存在すれば登録できる" do
        expect(@user).to be_valid
      end
      it "passwordが 6文字以上かつ半角英数字含む であれば登録できる" do
        @user.password = "a12345"
        @user.password_confirmation = "a12345"
        expect(@user).to be_valid
      end  
    end 
  
  
    context "新規登録がうまくいかないとき" do  
      it "nicknameが空では登録できない" do
        @user.nickname = ""
        @user.valid?
        expect(@user.errors[:nickname]).to include "を入力してください"
      end

      it "emailが空では登録できない" do
        @user.email = ""
        @user.valid?
        expect(@user.errors[:email]).to include "を入力してください"
      end
      it "emailは＠が含まれていないと登録できない" do
        @user.email = "test.com"
        @user.valid?
        expect(@user.errors[:email]).to include "は不正な値です"
      end

      it "passwordが空では登録できない" do
        @user.password = ""
        @user.valid?
        expect(@user.errors[:password]).to include "を入力してください"
      end
      it "passwordが5文字以下では登録できない" do
        @user.password = "a1234"
        @user.valid?
        expect(@user.errors[:password]).to include "は6文字以上で入力してください"
      end
      # it "passwordが数字のみでは登録できない" do
      #   @user.password = "123456"
      #   @user.valid?
      #   expect(@user.errors[:password]).to include "英字と数字の両方を含めて設定してください"
      # end
      # it "passwordが英字のみでは登録できない" do
      #   @user.password = "abcdef"
      #   @user.valid?
      #   expect(@user.errors[:password]).to include "英字と数字の両方を含めて設定してください"
      # end
    end
  end
end