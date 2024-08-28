module Scenes
  module Game
    module Card
      class Card7 < Base
        def initialize(x, y, z)
          self.imagesorce = "images/card7.png"  # カードの画像を設定
          super(7, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "Suit2"  # カードのスートを設定
          @effect_text = "効果説明"  # カードの効果を設定
        end
      end

      class Effect7
        attr_accessor :p1_wol, :p2_wol
        def initialize(p1_deck, p2_deck, order, p1_wol, p2_wol)
          @p1_deck = p1_deck
          @p2_deck = p2_deck
          @order = order
          @p1_wol = p1_wol
          @p2_wol = p2_wol
        end

        def judge
          @p1_wol = "U"
          @p2_wol = "U"
        end
      end
    end
  end
end