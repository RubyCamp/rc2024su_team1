require_relative 'card/base'
require_relative 'card/No.1_yaegakishrine'
require_relative 'card/No.2_yamatanooroti'
require_relative 'card/No.3_matuecastle'
require_relative 'card/No.4_loach'
require_relative 'card/No.5_matcha'
require_relative 'card/No.6_izumosoba'
require_relative 'card/No.7_sanreiku'
require_relative 'card/No.8_izumotemple'
#require_relative '../director_base'

module Scenes
  module Game
    # ゲーム本編シーンの担当ディレクタークラス
    class Director < DirectorBase
      SUIT_AMOUNT = 13                  # 各マーク毎のカード枚数
      CORRECTED_MESSAGE = "当たり！！"    # 開いた2枚のカードの番号が一致した場合（当たり）の表示メッセージ
      INCORRECTED_MESSAGE = "ハズレ！！"  # 開いた2枚のカードの番号が一致しなかった場合（ハズレ）の表示メッセージ
      CORRECTED_SCORE = 10              # 当たりの際に追加される点数
      INCORRECTED_SCORE = 1             # ハズレの際に引かれる点数
      GAME_CLEAR_SCORE = 10             # ゲームクリアに必要な点数（サンプルのため、1回分の当たり点数と同じにしている）
      MESSAGE_DISPLAY_FRAMES = 60       # 当たり／ハズレのメッセージを画面上に表示しておくフレーム数（60フレーム＝2秒）
      JUDGEMENT_MESSAGE_Y_POS = 250     # 当たり／ハズレのメッセージを表示するY座標
      TIMELIMIT_BAR_Z_INDEX = 3500      # 当たり／ハズレのメッセージを表示するZ座標（奥行）
      TIMELIMIT_SEC = 60                # タイムリミットバーの最大秒数
      TIMELIMIT_BAR_MARGIN = 5          # タイムリミットバーの表示上の余白サイズ（ピクセル）
      FPS = 30                          # 1秒間の表示フレーム数

      # コンストラクタ
      def initialize
        super
        # 画像オブジェクトの読み込み
        @bg_img = Gosu::Image.new("images/bg_game.png", tileable: true)
        @timelimit_bar = Gosu::Image.new("images/timelimit_bar.png", tileable: true)
        @bgm = load_bgm("bgm2.mp3", 0.1)

        # 各種インスタンス変数の初期化
        @cards = []                                            # 全てのカードを保持する配列
        @opened_cards = []                                     # オープンになっているカードを保持する配列
        @message_display_frame_count = 0                       # メッセージ表示フレーム数のカウンタ変数
        @judgement_result = false                              # 当たり／ハズレの判定結果（true: 当たり）
        @score = 0                                             # 総得点
        @cleared = false                                       # ゲームクリアが成立したか否かを保持するフラグ
        @timelimit_scale = 1.0                                 # タイムリミットバー画像の初期長さ（割合で減衰を表現する）
        @timelimit_decrease_unit = 1.0 / TIMELIMIT_SEC / FPS   # タイムリミットバーの減衰単位
        @drag_start_pos = nil                                  # マウスドラッグ用フラグ兼ドラッグ開始位置記憶用変数
        @offset_mx = 0                                         # マウスドラッグ中のカーソル座標補正用変数（X成分用）
        @offset_my = 0                                         # マウスドラッグ中のカーソル座標補正用変数（Y成分用）
        #@card = Card::Space.new(1, 400, 400, 1)

        @original_array = [1, 1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7, 8]
        element = @original_array.sample # ランダムに1つの要素を取得
        @original_array.delete(element) # 取得した要素を削除
        @deck = @original_array.shuffle
        @idx = 2

        @p1_deck = [] #player1の手札
        @p2_deck = [] #player2の手札

        @p1_wol = "U" #player1の勝敗
        @p2_wol = "U" #player2の勝敗

        @order = "None"
        @current_card = -1
        @previous_card = -1

        @skip_7 = false #7を引いた時のeffectスキップ

        @start_flag = true #ゲーム開始のフラグ
        @board = 1         #ボードパターン(1:初期, 2:引く, )
        @pros_flag = false #ゲーム進行のflag
        @please_pick = false #カードを引く動作
        @please_choose = false #カードを選ぶ動作
        @waiting_for_click = false # マウスクリック待機のフラグ

        @bg_img = Gosu::Image.new("images/game_back.jpg", tileable: true)

        setup_game
      end

      def setup_game
        puts "シャッフル前: #{@original_array}"
        puts "シャッフル後: #{@deck}"
      
        # 先攻、後攻を決める
        start_order = [1, 2].shuffle
        @order = start_order[0] == 1 ? "p1" : "p2"
      
        if @order == "p1"
          @p1_deck << @deck[0]
          @p2_deck << @deck[1]
        else
          @p1_deck << @deck[1]
          @p2_deck << @deck[0]
        end
      
        puts "@p1_deck: #{@p1_deck.inspect}"
        puts "@p2_deck: #{@p2_deck.inspect}"
      end

      def process_turns
        while @idx < 14
          puts "#{@order}のターンです。"
          if @order == "p1"
            #山札クリック
            @please_pick = true
            @p1_deck.unshift(@deck[@idx])
            puts "カードを引きました。#{@p1_deck}"
            #引っかかり
            if @deck[@idx] == 7 && (@p1_deck[1] == 5 || @p1_deck[1] == 6)
              @current_card = @p1_deck[1]
              @p1_deck.delete_at(1)
              @skip_7 = true
            else
              @please_choose = true
              #引っかかり
              puts "左のカードを出す"
              @current_card = @p1_deck[0]
              @p1_deck.delete_at(0)
            end
          else
            @please_pick = true
            @p2_deck.unshift(@deck[@idx])
            puts "カードを引きました。#{@p2_deck}"
            #引っかかり
            if @deck[@idx] == 7 && (@p2_deck[1] == 5 || @p2_deck[1] == 6)
              @current_card = @p2_deck[1]
              @p2_deck.delete_at(1)
              @skip_7 = true
            else
              @please_choose = true
              #引っかかり
              puts "左のカードを出す"
              @current_card = @p2_deck[0]
              @p2_deck.delete_at(0)
            end
          end
          @idx += 1
          @please_choose = false

          puts "current_card:#{@current_card}"
          case @current_card
          when 1
            card_effect = Card::Effect1.new(@p1_deck, @p2_deck, @order, @p1_wol, @p2_wol)
          when 2
            card_effect = Card::Effect2.new(@p1_deck, @p2_deck, @order, @p1_wol, @p2_wol)
          when 3
            card_effect = Card::Effect3.new(@p1_deck, @p2_deck, @order, @p1_wol, @p2_wol)
          when 4
            card_effect = Card::Effect4.new(@p1_deck, @p2_deck, @order, @p1_wol, @p2_wol)
          when 5
            card_effect = Card::Effect5.new(@p1_deck, @p2_deck, @order, @p1_wol, @p2_wol)
          when 6
            card_effect = Card::Effect6.new(@p1_deck, @p2_deck, @order, @p1_wol, @p2_wol)
          when 7
            card_effect = Card::Effect7.new(@p1_deck, @p2_deck, @order, @p1_wol, @p2_wol)
          when 8
            card_effect = Card::Effect8.new(@p1_deck, @p2_deck, @order, @p1_wol, @p2_wol)
          end
      
          if @previous_card != 4 && !@skip_7
            card_effect.judge
            if @current_card == 5 && @idx < 14
              if @order == "p1"
                @p2_deck.unshift(@deck[@idx])
              else
                @p1_deck.unshift(@deck[@idx])
              end
              @idx += 1
            end
          end
          @skip_7 = false

          @p1_wol = card_effect.p1_wol
          @p2_wol = card_effect.p2_wol
      
          if @p1_wol != "U" && @p2_wol != "U"
            puts "勝負あり"
            if @p1_wol == "W"
              $winner = "player1"
            else
              $winner = "player2"
            end
            puts "p1の勝敗:#{@p1_wol}  p2の勝敗:#{@p2_wol}"
            break
          end
      
          @order = (@order == "p1") ? "p2" : "p1"
          @previous_card = @current_card
          @current_card = -1
      
          puts ""
          puts "Next"
        end
      end
      


      # 1フレーム分の更新処理
      def update(opt = {})
        mx = opt.has_key?(:mx) ? opt[:mx] : 0
        my = opt.has_key?(:my) ? opt[:my] : 0

        if $phase == 1 && @start_flag
          process_turns
          @start_flag = false
        end

        if @waiting_for_click && Gosu.button_down?(Gosu::MsLeft)
          @waiting_for_click = false
        end

        if @board == 1 && @please_pick
          # 山札エリアのクリック検出
          if Gosu.button_down?(Gosu::MsLeft) && mx > 600 && mx < 750 && my > 200 && my < 400
            @board = 2
            @please_pick = false
            @please_choose = true
          end
        end

        if @board == 2 && @please_choose
          #左のカード選択
          if Gosu.button_down?(Gosu::MsLeft) && mx > 100 && mx < 250 && my > 350 && my < 550
            @board = 1
            @please_choose = false
            @please_pick = true
          end
          
          #右のカード選択
          if Gosu.button_down?(Gosu::MsLeft) && mx > 350 && mx < 500 && my > 350 && my < 550
            @board = 1
            @please_choose = false
            @please_pick = true
          end
        end
 
        # BGMをスタートする（未スタート時のみ）
        #@bgm.play if @bgm && !@bgm.playing?
        

        # マウスの現在座標を変数化しておく

=begin
        if Gosu.button_down?(Gosu::MsLeft)
          puts mx > 225 && mx < 
        end
=end

        # ゲームクリアフラグが立ち、且つ画面への判定結果表示が完了済みの場合、エンディングシーンへ切り替えを行う
        #if @cleared && @message_display_frame_count == 0
          #@bgm.stop if @bgm && @bgm.playing?
        if key_push?(Gosu::KB_SPACE)
          transition(:ending)
        end

=begin
        if(@p1_deck.length == 1)
          @card1 = Card::Base.new(@p1_deck[0], 225, 300, 1)
        elsif(@p1_deck.length == 2)
          @card1 = Card::Base.new(@p1_deck[0], 100, 350, 1)
          @card2 = Card::Base.new(@p1_deck[1], 350, 350, 1)
        end

        # 相手の手札
        if(@p2_deck.length == 1)
          @card2 = Card::Base.new(@p1_deck[0], 225, 300, 1)
        elsif(@p2_deck.length == 2)
          @card2 = Card::Base.new(@p1_deck[0], 100, 350, 1)
          @card3 = Card::Base.new(@p1_deck[1], 350, 350, 1)
        end
=end

        # メッセージ表示中とそれ以外で処理を分岐
        if @message_display_frame_count > 0
          # メッセージ表示中の場合
          # メッセージ表示フレーム数をデクリメントし、残り1フレーム分まで来たら開いているカードに関する後処理を行う
          # NOTE: このように実装することで、メッセージ表示中はマウスクリック等が反応しないようにしている
          @message_display_frame_count -= 1
          cleaning_up if @message_display_frame_count == 1
        else
          # メッセージ非表示の場合
          # マウスクリック及び合致判定を実施する
          #check_mouse_operations(mx, my)
          #judgement
        end
      end

      # 1フレーム分の描画処理
      def draw
        @bg_img.draw(0, 0, 0)
        # 背景画像を表示
        if @board == 2
          Gosu.draw_rect(100, 350, 150, 200, Gosu::Color::GREEN) #手前の左
          Gosu.draw_rect(350, 350, 150, 200, Gosu::Color::GREEN) #手前の右

          Gosu.draw_rect(600, 200, 150, 200, Gosu::Color::GREEN) #山札

          Gosu.draw_rect(225, 50, 150, 200, Gosu::Color::GREEN) #相手の手札
        else
          Gosu.draw_rect(225, 350, 150, 200, Gosu::Color::GREEN) #自分の手札

          Gosu.draw_rect(600, 200, 150, 200, Gosu::Color::GREEN) #山札

          Gosu.draw_rect(225, 50, 150, 200, Gosu::Color::GREEN) #相手の手札
        end
        
=begin
        # 全カードを表示
        # NOTE: 重なり合わせを適正に表現するため、各カードの最新Z値でソートして表示する（マウスクリックでカードのZ値が変化するため）
        @cards.sort_by{|c| c.z }.each do |card|
          card.draw
        end


        # メッセージ表示フレーム数が2以上の場合はメッセージを表示する
        if @message_display_frame_count > 1
          draw_text(@message_body, :center, JUDGEMENT_MESSAGE_Y_POS, font: :judgement_result, color: @message_color)
        end
=end

        # スコアを表示
        #draw_text("SCORE: #{@score}", :right, 5, font: :score, color: :white)
      end

      private

      # 2枚のカードがオープンされた状況における当たり／ハズレ判定処理
      def judgement
        return if @opened_cards.size != 2 # 開かれているカードが2枚でなければ何もしない

        # 開かれた2枚のカードの合致判定
        if @opened_cards.first.num == @opened_cards.last.num
          # 合致していた場合
          @judgement_result = true
          @score += CORRECTED_SCORE
          @message_body = CORRECTED_MESSAGE
          @message_color = :blue

          # 加算後のスコアが条件を満たす場合、ゲームクリアフラグを立てる
          if @score >= GAME_CLEAR_SCORE
            @cleared = true
          end
        else
          # 合致していなかった場合
          @judgement_result = false
          @score -= INCORRECTED_SCORE
          @message_body = INCORRECTED_MESSAGE
          @message_color = :red
        end

        # 当たっても外れても、いずれにしてもメッセージは表示するので、メッセージ表示フレーム数を設定する
        @message_display_frame_count = MESSAGE_DISPLAY_FRAMES
      end

      # マウスによる操作判定
=begin
      def check_mouse_operations(mx, my)
        if Gosu.button_down?(Gosu::MsLeft)
          # マウスの左ボタンがクリックされている場合
          unless @drag_start_pos
            # マウスドラッグが開始されていない場合、現在のマウス座標からドラッグを開始する
            start_drag(mx, my)
            @drag_start_pos = [mx, my]
          else
            # マウス左クリック＆ドラッグ開始済みであるため、ドラッグ中と判定し処理を実施する
            dragging(mx, my)
          end
        else
          # マウスの左ボタンが解放されている場合
          # ドラッグ中であれば、ドロップ処理を実施し、ドラッグ中フラグを下ろす
          dropped if @drag_start_pos
          @drag_start_pos = nil
        end
      end
=end
      # 新規ドラッグ開始時の処理
      # マウスカーソル座標上に存在する最もZ値の高いカードをオープンし、掴んだ状態にする
      def start_drag(mx, my)
        # 判定対象となるカードを一時的にまとめるための配列を初期化
        clicked_cards = []

        # 全カードに対して、現在のマウス座標が自身の表示エリアに被っているか判定させ、被っているカードを配列に納めていく
        @cards.each do |card|
          clicked_cards << card if card.clicked?(mx, my)
        end

        # マウスカーソルの座標上に1枚以上カードが存在する場合
        if clicked_cards.size > 0
          # マウス座標と被っているカードが1個以上ある場合、そのZ座標（重なり具合）でソートし、最も上にあるカードのみをオープンする
          @opened_card = clicked_cards.sort_by{|c| c.z }.last
          @opened_card.open

          # クリックされたカードのZ値を、全てのカードに対して最大化する（一番上に重なるようにする）
          @opened_card.z = @cards.max_by{|c| c.z }.z + 1

          # マウス座標とクリックされたカードの左上座標の差分をドラッグ時のオフセット値として保存する。
          @offset_mx = mx - @opened_card.x
          @offset_my = my - @opened_card.y
        end
      end

      # ドラッグ中に発生する処理
      def dragging(mx, my)
        # 現在開いているカードが無い場合は何もしない（移動するべき対象物が無いため）
        return unless @opened_card

        # 現フレームにおけるマウス座標がドラッグ開始位置と同一の場合は何もしない
        return if @drag_start_pos == [mx, my]

        # 上記いずれにも該当しない場合、対象カードの座標を移動する
        # NOTE: その際、ドラッグ開始時点で保存したオフセット値を引くことで、マウス座標が不自然に移動することを防止する
        @opened_card.x = mx - @offset_mx
        @opened_card.y = my - @offset_my
      end

      # ドラッグに対するドロップ処理
      def dropped
        # オープン済みカードが無ければ何もしない
        return unless @opened_card

        # オープンされたカードが既にオープン済みでなければ、オープン済みカードリストに追加する
        @opened_cards << @opened_card unless @opened_cards.include?(@opened_card)
        @opened_card = nil
      end

=begin
      # 開いたカードの後始末を行う
      def cleaning_up
        # 判定結果に沿って開いたカードの状態を変化させる
        # * 一致した場合： 開いたカードを消去
        # * 一致しなかった場合： 開いたカードを閉じるのみ
        @opened_cards.each do |c|
          c.reverse
          @cards.delete(c) if @judgement_result
        end
=end
        # 開いたカードリストをクリア
        #@opened_cards.clea
    end
  end
end