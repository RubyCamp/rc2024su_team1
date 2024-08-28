module Scenes
  module Game
    module Card
      OPEN_EFFECT_SOUND_FILENAME = "effect1.mp3"

      # カードの共通項目
      class Base
        @@card_foreground_img = Gosu::Image.new("images/card_foreground.png", tileable: true)    # カードの表面画像（数字がある側）
        @@card_background_img = Gosu::Image.new("images/card_background.png", tileable: true)    # カードの裏面画像
        @@suit_font = Gosu::Font.new(40, name: DirectorBase::FONT_FILENAME)                      # カードのマーク描画用フォント
      

        # カードを裏返す際に鳴らす効果音読み込み
        # NOTE: インスタンス変数と違い、クラス変数は明確に初期化しないとnilとして扱われないので、ファイルが無い場合のnilを明確に代入しておく
        @@open_effect = nil
        @@open_effect = Gosu::Sample.new(OPEN_EFFECT_SOUND_FILENAME) if File.exist?(OPEN_EFFECT_SOUND_FILENAME)

        WIDTH = 150              # カード横幅（px）
        HEIGHT = 200             # カード高さ（px）
        SUIT_MARK_OFFSET_X = 5   # カードの種別マークのX方向表示位置（カードの左上からの相対値）
        SUIT_MARK_OFFSET_Y = 5   # カードの種別マークのY方向表示位置（カードの左上からの相対値）
        SCALE = 1                # 描画時の表示倍率
        IMGS = {
            1 => Gosu::Image.new("images/yaegakishrine_dot.png", tileable: true),
            2 => Gosu::Image.new("images/yamatanoorochi_dot.png", tileable: true),
            3 => Gosu::Image.new("images/matsuecastle_dot.png", tileable: true),
            4 => Gosu::Image.new("images/No4dojou.png", tileable: true),
            5 => Gosu::Image.new("images/No5mattya.png", tileable: true),
            6 => Gosu::Image.new("images/izumosoba_dot.png", tileable: true),
            7 => Gosu::Image.new("images/sunreiku_dot.png", tileable: true),
            8 => Gosu::Image.new("images/izumotaisha_dot.png", tileable: true),
          }

        # 必要なアクセサメソッドの定義
        attr_accessor :num, :x, :y, :z

        # コンストラクタ
        def initialize(_num, _x, _y, _z = 1)
          @reversed = false  # 裏返しになっているかどうか（true: 裏）
          self.num = _num
          self.x = _x
          self.y = _y
          self.z = _z
          
          @number_mark = self.num.to_s
        end

        # カードの表示を表に変更
        def open
          @reversed = false
          @@open_effect.play if @@open_effect
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
          @@card_foreground_img.draw(self.x, self.y, self.z)
          draw_suit_mark
          draw_number
        end

        # カードの種別マーク（Suit）の描画
        def draw_suit_mark
          @@suit_font.draw_text(
            @num.to_s,
            self.x + SUIT_MARK_OFFSET_X,
            self.y + SUIT_MARK_OFFSET_Y,
            self.z,
            SCALE, SCALE,
            0xff_000000)
        end

        # カードの描画
        def draw_number
            @img = IMGS[@num]
          
            num_x = self.x + (@@card_foreground_img.width / 2) - 62
            num_y = self.y + (@@card_foreground_img.height / 2) - 50
            @img.draw(num_x,num_y,10)
        end
      end
    end
  end
end
