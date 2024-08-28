module Scenes
  module Game
    module Card
      class Card3 < Base
        def initialize(x, y, z)
          @imagesorce = "images/card1.png"  # カードの画像を設定
          super(3, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "Suit2"  # カードのスートを設定
          @effect_text = "効果説明"  # カードの効果を設定
        end
      end

      class Effect3
        attr_accessor :p1_wol, :p2_wol
        def initialize(p1_deck, p2_deck, order, p1_wol, p2_wol)
          @p1_deck = p1_deck
          @p2_deck = p2_deck
          @order = order
          @p1_wol = p1_wol
          @p2_wol = p2_wol
        end

        def judge
          if @p1_deck[0] > @p2_deck[0]
            @p1_wol = "W"
            @p2_wol = "L"
          elsif @p1_deck[0] < @p2_deck[0]
            @p1_wol = "L"
            @p2_wol = "W"
          else
            @p1_wol = "U"
            @p2_wol = "U"
          end
        end
      end
    end
  end
end