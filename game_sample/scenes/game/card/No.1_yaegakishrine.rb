# Card1ファイル (No.1_yaegakishrine.rb)
module Scenes
  module Game
    module Card
      class Card1 < Base
        def initialize(x, y, z)
          self.imagesorce = "images/card1.png"  # カードの画像を設定
          super(1, x, y, z) # Base クラスの initialize メソッドを呼び出す
          @suit = "Suit1"  # カードのスートを設定
          @effect_text = "効果説明"  # カードの効果を設定
        end
      end
    end
  end
end