module Scenes
  module Title
    # タイトルシーンの担当ディレクタークラス
    class Director < DirectorBase
      MAX_SNOW = 2000
      # コンストラクタ
      def initialize
        super
        @bg_img = Gosu::Image.new("images/bg_title.png", tileable: true)
        @bgm = load_bgm("bgm1.mp3", 0.3)

        @snow = Array.new(MAX_SNOW) { Snow.new }
        
        @cnt = 0
        @faze = 0
        @bg_color = Gosu::Color::BLUE # 初期背景色
      end

      # 1フレーム分の更新処理DAR
      def update(opt = {})
        @bgm.play if @bgm && !@bgm.playing?
        # スペースキー押下でゲーム本編シーンへ切り替えを行う

        if key_push?(Gosu::KB_SPACE)
          transition(:game)
          @bgm.stop if @bgm && @bgm.playing?
        end

        @cnt+=1
        
        if @faze==0
          (@snow.length - 1).downto(0) do |i|
            @snow[i].update
            #@snow.delete_at(i) if @snow[i].kill
          end
          
          if @cnt == 150
            @faze = 1
          end
        elsif @faze == 1
          (@snow.length - 1).downto(0) do |i|
            @snow[i].update
          end
          
          fade_out_snow

          if @snow.length == 0
            @faze = 2 
          end
        elsif @faze == 2
          
        end


      end

      # 1フレーム分の描画処理
      def draw
        Gosu.draw_rect(0, 0, 800, 600, Gosu::Color::BLACK)
        @snow.each(&:draw)

        # @bg_img.draw(0, 0, 0)
        draw_text("Ruby合宿2024夏", :center, 280, font: :title, color: :red)
        draw_text("Push SPACE Key to start", :center, 350)
      end


      def fade_out_snow
        # 徐々に雪の量を減らす
        @snow.pop(MAX_SNOW / 300) if @snow.length > 0
        
        # 背景色を徐々に青空に近づける
        target_color = Gosu::Color::CYAN
        @bg_color = Gosu::Color.new(
          [@bg_color.red - 1, target_color.red].max,
          [@bg_color.green - 1, target_color.green].max,
          [@bg_color.blue + 1, target_color.blue].min
        )
      end
    end

    class Snow    
      def initialize
        @x = rand(-800..800)#HC
        @y = rand(600)#HC
        @vx = 1
        @vy = rand(100..300)/60
        @sz = rand(1..2)
      end

      def draw
        Gosu.draw_rect(@x, @y, @sz, @sz, rand(2) != 0 ? Gosu::Color::BLUE : Gosu::Color::CYAN)
      end

      def update
        @x += @vx
        @y += @vy
        @y = 0 if @y > 600#HC
      end
    end

    def kill
      false  # 雪は削除しないため、常に`false`を返す
    end



  end
end