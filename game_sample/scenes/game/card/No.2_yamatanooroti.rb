module Scenes
  module Game
    module Card
      class Card2 < Base
        def initialize(x, y, z)
          self.imagesorce = "images/card2.png"  # カードの画像を設定
          super(2, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "Suit2"  # カードのスートを設定
          @effect_text = "you are death\nenemy is winner"  # カードの効果を設定
        end
      end

      class Effect2
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
            puts @p2_deck
          else
            puts @p1_deck
          end
        end
      end
    end
  end
end