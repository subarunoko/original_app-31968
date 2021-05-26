require 'rails_helper'

RSpec.describe ArticleTag, type: :model do
  before do
    @article = FactoryBot.build(:article_tag)
  end

  describe "記事投稿機能" do
    context "新規記事投稿がうまくいくとき" do
      it "title等が存在すれば登録できる" do
        expect(@article).to be_valid
      end
    end 
   
    context "新規記事投稿がうまくいかないとき" do  
      it "titleが空では登録できない" do
        @article.title = ""
        @article.valid?
        expect(@article.errors[:title]).to include "を入力してください"
      end
      it "titleが31文字以上では登録できない" do
        'require {"securerandom"}'
        @article.title = SecureRandom.alphanumeric(31)
        @article.valid?
        expect(@article.errors[:title]).to include "の文字数の上限を超えてます\n修正して下さい" 
      end

      it "bodyが空では登録できない" do
        @article.body = ""
        @article.valid?
        expect(@article.errors[:body]).to include "を入力してください"
      end
      it "bodyが2001文字以上では登録できない" do
        @article.body = SecureRandom.alphanumeric(2001)
        @article.valid?
        expect(@article.errors[:body]).to include "の文字数の上限を超えてます\n修正して下さい" 
      end

      it "tagが空では登録できない" do
        @article.tag_ids = ""
        @article.valid?
        expect(@article.errors[:tag_ids]).to include "を入力してください"
      end      

      it "カンマが含んでいるとtagは登録できない" do
        @article.tag_ids = "tag1,"
        @article.valid?
        expect(@article.errors[:tag_ids]).to include "　カンマは使用できません\n半角スペースへ修正して下さい"
      end 

      it "ピリオドが含んでいるとtagは登録できない" do
        @article.tag_ids = "tag1."
        @article.valid?
        expect(@article.errors[:tag_ids]).to include "　ピリオドは使用できません\n半角スペースへ修正して下さい"
      end

      it "ハイフンが含んでいるとtagは登録できない" do
        @article.tag_ids = "tag1-"
        @article.valid?
        expect(@article.errors[:tag_ids]).to include "　ハイフンは使用できません\n半角スペースへ修正して下さい"
      end

      it "読点が含んでいるとtagは登録できない" do
        @article.tag_ids = "tag1、"
        @article.valid?
        expect(@article.errors[:tag_ids]).to include "　読点は使用できません\n半角スペースへ修正して下さい"
      end

      it "句点が含んでいるとtagは登録できない" do
        @article.tag_ids = "tag1。"
        @article.valid?
        expect(@article.errors[:tag_ids]).to include "　句点は使用できません\n半角スペースへ修正して下さい"
      end

      it "全角スペースが含んでいるとtagは登録できない" do
        @article.tag_ids = "tag1　"
        @article.valid?
        expect(@article.errors[:tag_ids]).to include "　全角スペースは使用できません\n半角スペースへ修正して下さい"
      end

      it "tagが6個以上だと登録できない" do
        @article.tag_ids = "tag1 tag2 tag3 tag4 tag5 tag6"
        @article.valid?
        expect(@article.errors[:tag_ids]).to include "のタグ数の上限を超えてます\n修正して下さい"
      end

      # it "imageが空では登録できない" do
      #   # @item.image = nil
      #   .images = nil
      #   @article.valid?
      #   # expect(@item.errors[:image]).to include "を入力してください"
      #   expect(@article.errors[:images]).to include "を入力してください"
      # end

    end
  end
end
