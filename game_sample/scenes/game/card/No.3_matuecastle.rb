module Scenes
  module Game
    module Card
      class Card3 < Base
        def initialize(x, y, z)
          self.imagesorce = "images/card_background.png"  # カードの画像を設定
          self.illustimage = "images/No3castle.jpg"
          super(3, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "3"  # カードのスートを設定
          @effect_text = "aite is back"  # カードの効果を設定
        end
      end
    end
  end
end