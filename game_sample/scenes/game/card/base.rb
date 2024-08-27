require 'gosu'  # 追加: Gosuを読み込む

module Scenes
  module Game
    module Card
      class Base
        @@suit_font = Gosu::Font.new(24, name: DirectorBase::FONT_FILENAME)  # マーク用フォント
        @@number_font = Gosu::Font.new(80, name: DirectorBase::FONT_FILENAME) # 数字用フォント
        @@effect_font = Gosu::Font.new(14, name: DirectorBase::FONT_FILENAME) # 効果用フォント

        WIDTH = 96   # カード横幅
        HEIGHT = 128 # カード高さ
        SCALE = 1    # 描画倍率

        attr_accessor :num, :x, :y, :z, :suit, :effect_text, :image

        def initialize(_num, _x, _y, _z = 1, image_path, suit, effect_text)
          @reversed = true # 裏返し状態かどうか
          self.num = _num
          self.x = _x
          self.y = _y
          self.z = _z
          self.suit = suit
          self.effect_text = effect_text
          @number_mark = get_number_mark
          @num_w = @@number_font.text_width(@number_mark)
          @num_h = @@number_font.height
          @suit_w = @@suit_font.text_width(self.suit)
          @suit_h = @@suit_font.height
          @effect_w = @@effect_font.text_width(self.effect_text)
          @effect_h = @@effect_font.height
          @image = Gosu::Image.new(image_path, tileable: true) # カードの表面画像を設定
        end

        # カードがクリックされたかを判定
        def clicked?(mx, my)
          x_included = self.x <= mx && mx <= self.x + WIDTH
          y_included = self.y <= my && my <= self.y + HEIGHT
          x_included && y_included
        end

        # カードを表にする
        def open
          @reversed = false
        end

        # カードを裏にする
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

        # カードの表側を描画
        def draw_foreground
          @image.draw(self.x, self.y, self.z)
          draw_suit
          draw_number
          draw_effect_text
        end

        # カードの裏側を描画
        def draw_background
          @@card_background_img ||= Gosu::Image.new("images/card_background.png", tileable: true)
          @@card_background_img.draw(self.x, self.y, self.z)
        end

        # カードのマーク（スート）を描画
        def draw_suit
          suit_x = self.x + WIDTH - @suit_w - 5
          suit_y = self.y + 5
          @@suit_font.draw_text(self.suit, suit_x, suit_y, self.z, SCALE, SCALE, Gosu::Color::WHITE)
        end

        # カードの数字を描画
        def draw_number
          num_x = self.x + (WIDTH / 2) - (@num_w / 2)
          num_y = self.y + (HEIGHT / 2) - (@num_h / 2)
          @@number_font.draw_text(@number_mark, num_x, num_y, self.z, SCALE, SCALE, Gosu::Color::WHITE)
        end

        # カードの効果テキストを描画
        def draw_effect_text
          effect_x = self.x + 5
          effect_y = self.y + HEIGHT - @effect_h - 5
          @@effect_font.draw_text(self.effect_text, effect_x, effect_y, self.z, SCALE, SCALE, Gosu::Color::WHITE)
        end

        # カードの数字を文字として取得
        def get_number_mark
          case self.num
          when 1 then "1"
          when 2 then "2"
          when 3 then "3"
          when 4 then "4"
          when 5 then "5"
          when 6 then "6"
          when 7 then "7"
          when 8 then "8"
          else
            self.num.to_s
          end
        end
      end
    end
  end
end
