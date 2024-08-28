module Scenes
  module Game
    module Card
      class Card8 < Base
        def initialize(x, y, z)
          self.imagesorce = "images/card8.png"
          super(8, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "Suit2"  # カードのスートを設定
          @effect_text = "効果説明"  # カードの効果を設定
        end
      end

      class Effect8
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
            @p1_wol = "L"
            @p2_wol = "W"
          else
            @p1_wol = "W"
            @p2_wol = "L"
          end
        end
      end
    end
  end
end
