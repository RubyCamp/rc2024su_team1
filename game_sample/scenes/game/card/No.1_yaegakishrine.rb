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

      class Effect1
        attr_accessor :p1_wol, :p2_wol
        def initialize(p1_deck, p2_deck, order, p1_wol, p2_wol)
          @p1_deck = p1_deck
          @p2_deck = p2_deck
          @order = order
          @p1_wol = p1_wol
          @p2_wol = p2_wol
        end

        def judge  
          puts "相手のカードはどれだと思いますか(1-8)：？"
          input = gets.chomp.to_i
          if @order == "p1"
            if input == @p2_deck[0]
              @p1_wol = "W"
              @p2_wol = "L"
            end
          else
            if input == @p1_deck[0]
              @p1_wol = "L"
              @p2_wol = "W"
            end
          end
        end
      end       
    end
  end
end