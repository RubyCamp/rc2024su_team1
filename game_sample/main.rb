require 'gosu'

class MainWindow < Gosu::Window
    def initialize
        super 800,600,false
        self.caption = 'ラブレター'
    end
end

def draw
    
end

window = MainWindow.new
window.show