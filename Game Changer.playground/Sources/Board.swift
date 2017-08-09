import UIKit

let CELL_SIZE = 30
let CELL_CORNER_RADIUS = 4

//Where BOARD_WIDTH & BOARD_HEIGHT units are # of cells
let BOARD_WIDTH = 10
let BOARD_HEIGHT = 20

let CELL_PADDING = 3
let BOARD_PADDING = 50

let VIEW_WIDTH = BOARD_WIDTH * (CELL_SIZE + CELL_PADDING) + BOARD_PADDING
let VIEW_HEIGHT = BOARD_HEIGHT * (CELL_SIZE + CELL_PADDING) + BOARD_PADDING

public class Board : UIView {
    
    public static let MAX_X = BOARD_WIDTH - 1;
    public static let MAX_Y = BOARD_HEIGHT - 1;

    public let cells : [[UIView]] = {
        
        var array = Array(repeating: Array(repeating: UIView(), count: BOARD_HEIGHT), count: BOARD_WIDTH)

        for w in 0 ... BOARD_WIDTH - 1 {
            for h in 0 ... BOARD_HEIGHT - 1 {
                
                array[w][h] = UIView(frame: CGRect(x: CGFloat(w * (CELL_SIZE + CELL_PADDING) + BOARD_PADDING / 2),
                                                   y: CGFloat(h * (CELL_SIZE + CELL_PADDING) + BOARD_PADDING / 2),
                                                   width: CGFloat(CELL_SIZE),
                                                   height: CGFloat(CELL_SIZE)))
                
                array[w][h].backgroundColor = #colorLiteral(red: 0.8070744821, green: 0.8070744821, blue: 0.8070744821, alpha: 1)
                array[w][h].layer.cornerRadius = CGFloat(CELL_CORNER_RADIUS)
            }
        }
        return array
    }()
    
    
    public init() {        
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: VIEW_WIDTH, height: VIEW_HEIGHT)))
        backgroundColor = #colorLiteral(red: 0.9395800624, green: 0.9395800624, blue: 0.9395800624, alpha: 1)
        
        for x in 0 ... BOARD_WIDTH - 1 {
            for y in 0 ... BOARD_HEIGHT - 1 {
                addSubview(cells[x][y])
            }
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setCells(colors: [[UIColor]]) {
        for x in 0 ... BOARD_WIDTH - 1 {
            for y in 0 ... BOARD_HEIGHT - 1 {
                self.cells[x][y].backgroundColor = colors[x][y]
            }
        }
    }
}
