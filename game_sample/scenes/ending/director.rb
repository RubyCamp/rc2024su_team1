module Scenes
  module Ending
    # エンディングシーンの担当ディレクタークラス
    class Director < DirectorBase
      # コンストラクタ
      def initialize
        super
        @bg_img = Gosu::Image.new("images/bg_ending.png", tileable: true)
        @bgm = load_bgm("bgm3.mp3", 0.3)
        puts $winner
      end

      # 1フレーム分の更新処理
      def update(opt = {})
        @bgm.play if @bgm && !@bgm.playing?
      end

      # 1フレーム分の描画処理
      def draw
        @bg_color = Gosu::Color::YELLOW

        if $winner == "player1" 
          draw_text("勝利者：player1", :center, 280, font: :title, color: :blue)
        else
          draw_text("勝利者：player2", :center, 280, font: :title, color: :blue)
        end

        draw_text("あ", :center, 350)
      end
    end
  end
end