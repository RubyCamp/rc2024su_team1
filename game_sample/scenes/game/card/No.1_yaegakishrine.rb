module Scenes
  module Game
    module Card
      class Card1 < Base
        def initialize(x, y, z = 1)
          super(1, x, y, z, "images/card1.png","sakana","このカードを出すとき")
        end
      end
    end
  end
end