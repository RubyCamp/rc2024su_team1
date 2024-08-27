module Scenes
  module Game
    module Card
      class Card6 < Base
        def initialize(_x, _y, _z = 1)
          super(6, _x, _y, _z, "images/card1.png","〇","このカードを出すとき")
        end
      end
    end
  end
end