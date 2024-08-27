module Scenes
  module Game
    module Card
      class Card1 < Base
        def initialize(x, y)
          # 親クラスの initialize メソッドを呼び出し、引数を渡す
          super(1, x, y, z, "images/card1.png", "suit", "effect_text")
        end
      end
    end
  end
end