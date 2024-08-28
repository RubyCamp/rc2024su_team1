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
    end
  end
end