module Scenes
  module Game
    module Card
      class Card3 < Base
        def initialize(x, y, z)
          @imagesorce = "images/card_background.png"  # カードの画像を設定
          super(3, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "Suit2"  # カードのスートを設定
          @effect_text = "効果説明"  # カードの効果を設定
        end
      end
    end
  end
end