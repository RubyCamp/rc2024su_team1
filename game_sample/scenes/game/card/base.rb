<<<<<<< HEAD
=======
require 'gosu'  # 追加: Gosuを読み込む
require_relative '../../director_base'

>>>>>>> utumi
module Scenes
  module Game
    module Card
      OPEN_EFFECT_SOUND_FILENAME = "effect1.mp3"

      # カードの共通項目
      class Base
<<<<<<< HEAD
        @@card_foreground_img = Gosu::Image.new("images/card_foreground.png", tileable: true)    # カードの表面画像（数字がある側）
        @@card_background_img = Gosu::Image.new("images/card_background.png", tileable: true)    # カードの裏面画像
        @@suit_font = Gosu::Font.new(24, name: DirectorBase::FONT_FILENAME)                      # カードのマーク描画用フォント
        @@number_font = Gosu::Font.new(80, name: DirectorBase::FONT_FILENAME)                    # カードの数字描画用フォント
=======
        @@suit_font = Gosu::Font.new(24, name: DirectorBase::FONT_FILENAME)  # マーク用フォント
        @@number_font = Gosu::Font.new(60, name: DirectorBase::FONT_FILENAME) # 数字用フォント
        @@effect_font = Gosu::Font.new(14, name: DirectorBase::FONT_FILENAME) # 効果用フォント
>>>>>>> utumi

        # カードを裏返す際に鳴らす効果音読み込み
        # NOTE: インスタンス変数と違い、クラス変数は明確に初期化しないとnilとして扱われないので、ファイルが無い場合のnilを明確に代入しておく
        @@open_effect = nil
        @@open_effect = Gosu::Sample.new(OPEN_EFFECT_SOUND_FILENAME) if File.exist?(OPEN_EFFECT_SOUND_FILENAME)

<<<<<<< HEAD
        WIDTH = 96               # カード横幅（px）
        HEIGHT = 128             # カード高さ（px）
        SUIT_MARK_OFFSET_X = 5   # カードの種別マークのX方向表示位置（カードの左上からの相対値）
        SUIT_MARK_OFFSET_Y = 5   # カードの種別マークのY方向表示位置（カードの左上からの相対値）
        SCALE = 1                # 描画時の表示倍率

        # 必要なアクセサメソッドの定義
        attr_accessor :num, :x, :y, :z

        # コンストラクタ
        def initialize(_num, _x, _y, _z = 1)
          @reversed = true  # 裏返しになっているかどうか（true: 裏）
=======
        attr_accessor :num, :x, :y, :z, :suit, :scale, :effect_text, :imagesorce, :illustimage

        def initialize(_num, _x, _y, _z = 1)
          @reversed = false # 裏返し状態かどうか
>>>>>>> utumi
          self.num = _num
          self.x = _x
          self.y = _y
          self.z = _z
          @number_mark = get_number_mark
          @num_w = @@number_font.text_width(@number_mark)
          @num_h = @@number_font.height
<<<<<<< HEAD
=======
          @suit_w = @@suit_font.text_width(self.suit)
          @suit_h = @@suit_font.height 
          @effect_w = @@effect_font.text_width(self.effect_text)
          @effect_h = @@effect_font.height
          @image = Gosu::Image.new(imagesorce, tileable: true) # カードの表面画像を設定
          @illustration = Gosu::Image.new(illustimage, tileable: true)#カードのイラスト
>>>>>>> utumi
        end

        # カード（自オブジェクト）がクリックされたか否かを判定する
        def clicked?(mx, my)
          x_included = self.x <= mx && mx <= self.x + WIDTH
          y_included = self.y <= my && my <= self.y + HEIGHT
          x_included && y_included
        end

        # カードの表示を表に変更
        def open
          @reversed = false
          @@open_effect.play if @@open_effect
        end

        # カードの表示を裏に変更
        def reverse
          @reversed = true
        end

        # カードを画面に描画する
        def draw
          if @reversed
            draw_background
          else
            draw_foreground
          end
        end

        private

        # カードの表側の描画
        def draw_foreground
<<<<<<< HEAD
          @@card_foreground_img.draw(self.x, self.y, self.z)
          draw_suit_mark
=======
          @image.draw(self.x, self.y, self.z)
          @illustration.draw(self.x, self.y, self.z)
          draw_suit
>>>>>>> utumi
          draw_number
        end

        # カードの裏側の描画
        def draw_background
          @@card_background_img.draw(self.x, self.y, self.z)
        end

        # カードの種別マーク（Suit）の描画
        def draw_suit_mark
          @@suit_font.draw_text(
            self.class::SUIT_MARK,
            self.x + SUIT_MARK_OFFSET_X,
            self.y + SUIT_MARK_OFFSET_Y,
            self.z,
            SCALE, SCALE,
            self.class::SUIT_COLOR)
        end

        # カードの番号の描画
        def draw_number
<<<<<<< HEAD
          num_x = self.x + (@@card_foreground_img.width / 2) - (@num_w / 2)
          num_y = self.y + (@@card_foreground_img.height / 2) - (@num_h / 2)
          @@number_font.draw_text(@number_mark, num_x, num_y, self.z, SCALE, SCALE, self.class::NUMBER_COLOR)
        end

        # カードの数字の表示上の文字を取得する
=======
          num_x = self.x + (WIDTH / 2) - (@num_w / 2) + 30
          num_y = self.y + (HEIGHT / 2) - (@num_h / 2) - 30
          @@number_font.draw_text(@number_mark, num_x, num_y, self.z, SCALE, SCALE, Gosu::Color::WHITE)
        end

        # カードの効果テキストを描画
        def draw_effect_text
          effect_x = self.x + 5
          effect_y = self.y + HEIGHT - @effect_h -50
          @@effect_font.draw_text(self.effect_text, effect_x, effect_y, self.z, SCALE, SCALE, Gosu::Color::WHITE)
        end

        # カードの数字を文字として取得
>>>>>>> utumi
        def get_number_mark
          case self.num
          when 1
            return "A"
          when 11
            return "J"
          when 12
            return "Q"
          when 13
            return "K"
          else
            return self.num.to_s
          end
        end
      end
    end
  end
end
