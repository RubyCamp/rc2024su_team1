module Scenes
  module Game
    module Card
      class Card2 < Base
        def initialize(x, y, z)
          self.imagesorce = "images/card_background.png"  # カードの画像を設定
          self.illustimage = "images/card1.png"
          super(2, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "Suit2"  # カードのスートを設定
          @effect_text = "you are death\nenemy is winner"  # カードの効果を設定
        end
      end
    end
  end
end