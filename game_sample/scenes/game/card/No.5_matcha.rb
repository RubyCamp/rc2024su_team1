module Scenes
  module Game
    module Card
      class Card5 < Base
        def initialize(x, y, z)
          @imagesorce = "images/card1.png"  # カードの画像を設定
          super(5, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "Suit2"  # カードのスートを設定
          @effect_text = "効果説明"  # カードの効果を設定
        end
      end

      class Effect5
        attr_accessor :p1_wol, :p2_wol
        def initialize(p1_deck, p2_deck, order, p1_wol, p2_wol)
          @p1_deck = p1_deck
          @p2_deck = p2_deck
          @order = order
          @p1_wol = p1_wol
          @p2_wol = p2_wol
        end

        def judge
          if @order == "p1"
            cast = @p2_deck.pop()
            if cast == 8
              @p1_wol = "W"
              @p2_wol = "L"
            end
          else
            cast = @p1_deck.pop()
            if cast == 8
              @p1_wol = "L"
              @p2_wol = "W"
            end
          end
        end
      end
    end
  end
end