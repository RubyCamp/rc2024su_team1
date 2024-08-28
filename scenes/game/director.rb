require_relative 'card/base'

module Scenes
  module Game
  # ゲーム本編シーンの担当ディレクタークラス
  class Director < DirectorBase
    SUIT_AMOUNT = 8                  # 各マーク毎のカード枚数

    # コンストラクタ
    def initialize
      super
      # 画像オブジェクトの読み込み
      @bg_img = Gosu::Image.new("images/bg_game.png", tileable: true)
      #山札を生成
      @card_deck = [1,1,1,1,1,2,2,3,3,4,4,5,5,6,7,8]
      @card_number = rand(0..@card_deck.size-1)
      @card=Card::Base.new(@card_deck[@card_number], 290, 390, 1)
      @card_deck.delete_at(@card_number)

      @drag_start_pos = nil                                  # マウスドラッグ用フラグ兼ドラッグ開始位置記憶用変数
      @offset_mx = 0                                         # マウスドラッグ中のカーソル座標補正用変数（X成分用）
      @offset_my = 0                                         # マウスドラッグ中のカーソル座標補正用変数（Y成分用)
    end

    # 1フレーム分の更新処理
    def update(opt = {})
      #Gosu.button_down?(Gosu::MsLeft)

    end

    # 1フレーム分の描画処理
    def draw
      # 背景画像を表示
      @bg_img.draw(0, 0, 0)

      # 全カードを表示
      # NOTE: 重なり合わせを適正に表現するため、各カードの最新Z値でソートして表示する（マウスクリックでカードのZ値が変化するため）
        @card.draw
  
    end

    private


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

    # 開いたカードの後始末を行う
    def cleaning_up
      # 判定結果に沿って開いたカードの状態を変化させる
      # * 一致した場合： 開いたカードを消去
      # * 一致しなかった場合： 開いたカードを閉じるのみ
      @opened_cards.each do |c|
        c.reverse
        @cards.delete(c) if @judgement_result
      end

      # 開いたカードリストをクリア
      @opened_cards.clear
    end
  end
  end
end