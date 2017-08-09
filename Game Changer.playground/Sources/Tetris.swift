import UIKit

public struct Tetra {
    public var shape : [Pos] = []
    public var position = Pos()
    public var angle : Int = 0
    public var color = #colorLiteral(red: 0.9395800624, green: 0.9395800624, blue: 0.9395800624, alpha: 1)
    
    public init() {}
    public init(shape: [Pos]) {
        self.shape = shape
    }
    
    public func getBlocks() -> [Pos] {
        var positions : [Pos] = []
        for b in shape  {
            var xPos = b.x
            var yPos = b.y
            
            if (angle >= 270) {
                xPos = b.y
                yPos = -b.x
            }
            else if (angle >= 180) {
                xPos = -b.x
                yPos = -b.y
            }
            else if (angle >= 90) {
                xPos = -b.y
                yPos = b.x
            }
            positions.append(Pos(x: xPos + position.x,
                                 y: yPos + position.y))
        }
        return positions
    }
}

public struct Block {
    public init(pos: Pos = Pos(), color: UIColor = #colorLiteral(red: 0.9395800624, green: 0.9395800624, blue: 0.9395800624, alpha: 1)) {
        self.pos = pos
        self.color = color
    }
    public var pos = Pos()
    public var color = #colorLiteral(red: 0.9395800624, green: 0.9395800624, blue: 0.9395800624, alpha: 1)
}
