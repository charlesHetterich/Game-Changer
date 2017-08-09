import UIKit
import PlaygroundSupport
/*:
# Tetris
In this section we'll get to explore how **Tetris** works and see what kind of interesting changes we can make. Just like Snake, some changes will be complicated while others will be very simple, making aesthetic, difficuly, and mechanical changes to the game.
 
### Game Constants
In the constants section here we again have `UPDATE_TIME` and `BACKGROUND_COLOR`, but now we also have `TETRA_COLORS` and `TETRA_TYPES`, where `TETRA_COLORS` consists of the possible colors of a tetra, and `TETRA_TYPES` consists of the possible kinds of tetra. Add or take away whatever colors and types you would like. If you're not too good at **Tetris** you can take away all of the types besides the **I**, or if you're good, add even more new types to the collection that you think will be interesting!
*/
let UPDATE_TIME = 0.5
let BACKGROUND_COLOR = #colorLiteral(red: 0.8070744821, green: 0.8070744821, blue: 0.8070744821, alpha: 1)
let TETRA_COLORS  = [#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
let TETRA_TYPES : [Tetra] = [Tetra(shape: [Pos(x: 0, y: 0),     //SQUARE-SHAPE
                                           Pos(x: 1, y: 0),
                                           Pos(x: 0, y: -1),
                                           Pos(x: 1, y: -1)]),
                             
                             Tetra(shape: [Pos(x: 0, y: 0),     //I-SHAPE
                                           Pos(x: 0, y: -1),
                                           Pos(x: 0, y: -2),
                                           Pos(x: 0, y: -3)]),
                             
                             Tetra(shape: [Pos(x: 0, y: 0),     //J-SHAPE
                                           Pos(x: 0, y: -1),
                                           Pos(x: 1, y: 0),
                                           Pos(x: 2, y: 0)]),
                             
                             Tetra(shape: [Pos(x: 0, y: 0),     //L-SHAPE
                                           Pos(x: 1, y: 0),
                                           Pos(x: 2, y: 0),
                                           Pos(x: 2, y: -1)]),
                           
                             Tetra(shape: [Pos(x: 0, y: 0),     //S-SHAPE
                                           Pos(x: -1, y: 0),
                                           Pos(x: 0, y: -1),
                                           Pos(x: 1, y: -1)]),
                           
                             Tetra(shape: [Pos(x: 0, y: 0),     //Z-SHAPE
                                           Pos(x: 1, y: 0),
                                           Pos(x: 0, y: -1),
                                           Pos(x: -1, y: -1)]),
                           
                             Tetra(shape: [Pos(x: 0, y: 0),     //T-SHAPE
                                           Pos(x: -1, y: 0),
                                           Pos(x: 1, y: 0),
                                           Pos(x: 0, y: -1)]),
                           
                             Tetra(shape: [Pos(x: 0, y: 0),     //C-SHAPE **NEW**
                                           Pos(x: -1, y: 0),
                                           Pos(x: -1, y: -1),
                                           Pos(x: -1, y: -2),
                                           Pos(x: 0, y: -2),]),
                           
                             Tetra(shape: [Pos(x: 0, y: 0),     //i-SHAPE **NEW**
                                           Pos(x: 0, y: -1),
                                           Pos(x: 0, y: -3)])]
/*:
### Tetris Class
Just like the `Pattern` and `Snake` classes, for **Tetris** we will be doing most of our experimenting here in the `Tetris` class.
*/
class Tetris : UIView {
/*:
### Variables
We have `board` and `cells` like the other sections, and we also have `blocks` and `tetra` here as our other member variables specific to **Tetris**. As you might be able to tell from their names, `blocks` is the pile of blocks on the board, and `tetra` is the current tetra that is falling
*/
    let board = Board()
    var cells : [[UIColor]] = Array(repeating: Array(repeating: BACKGROUND_COLOR, count: Board.MAX_Y + 1), count: Board.MAX_X + 1)
    
    var blocks : [Block] = []
    var tetra : Tetra = Tetra()
/*:
### Set Up
Our set up here is similar to how we did our setup in **Snake**. We call `begin()`, we call the initial `update()` that will call itself every `UPDATE_TIME` seconds, and we set up `swipe()` to retrieve input whenever the user swipes up, down, left, or right. If you want to change the controls, you can go into `swipe()` and move things around.
*/
    init() {
        super.init(frame: .zero)
        begin()
        update()
        
        //add user input
        for direction : UISwipeGestureRecognizerDirection in [.left, .right, .up, .down] {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            gesture.direction = direction
            board.addGestureRecognizer(gesture)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//: > Unlike **Snake**, we redraw after recieving an input because this input effects a seperate movement than the movement that happens in the update function, and because of that we want the user to be able to see the change they made right away.
    func swipe(recognizer:UIGestureRecognizer?) {
        guard let recognizer = recognizer as? UISwipeGestureRecognizer else {
            return
        }
        switch recognizer.direction {
        case UISwipeGestureRecognizerDirection.right:
            move(rightBy: 1)
        case UISwipeGestureRecognizerDirection.left:
            move(rightBy: -1)
        case UISwipeGestureRecognizerDirection.up:
            rotate(clockwiseBy: 270)
        case UISwipeGestureRecognizerDirection.down:
            rotate(clockwiseBy: 90)
        default:
            break
        }
        draw()
    }
/*:
### Begin
All we have to do to begin the game is simply create a new tetra. If you make any new variables that need to be defined at the start of the program, define them here.
*/
    func begin() {
        newTetra()
    }
/*:
### Update
Just like in **Snake** we follow the rule of **[Input -> Move -> Collisions -> Draw]**. You will see in the movement functions that the collisions are checked from there.
*/
    func update() {
        fall()
        draw()
        DispatchQueue.main.asyncAfter(deadline: .now() + UPDATE_TIME) { self.update() }
    }
/*:
### Movement
The movement in **Tetris** is a bit more complicated than the movement in **Snake** we have **3** functions for movement: `fall()`, `move()`, and `rotate()`.
*/
    func fall() {
        tetra.position = Pos(x: tetra.position.x, y: tetra.position.y + 1)
        if (collision() || outOfBounds()) {
            tetra.position = Pos(x: tetra.position.x, y: tetra.position.y - 1)
            newTetra()
        }
    }
    
    func move(rightBy: Int) {
        tetra.position = Pos(x: tetra.position.x + rightBy, y: tetra.position.y)
        if (collision() || outOfBounds()) {
            tetra.position = Pos(x: tetra.position.x - rightBy, y: tetra.position.y)
        }
    }
    
    func rotate(clockwiseBy: Int) {
        tetra.angle = (tetra.angle + clockwiseBy) % 360
        if (collision() || outOfBounds()) {
            rotate(clockwiseBy: 360 - clockwiseBy)
        }
    }
/*:
### Collisions
There are two types of collision checks we make each time we make a movement: `outOfBounds()`, which tells us if the tetra has gone out of bounds, and `collision()`, which tells us if the tetra has collided with any of the blocks.
*/
    func outOfBounds() -> Bool {
        for pos in tetra.getBlocks() {
            if (pos.x < 0 || pos.x > Board.MAX_X || pos.y > Board.MAX_Y) {
                return true
            }
        }
        return false
    }
    
    func collision() -> Bool {
        for pos in tetra.getBlocks() {
            for b in blocks {
                if (pos.x == b.pos.x && pos.y == b.pos.y) {
                    return true
                }
            }
        }
        return false
    }
/*:
### Clearing Rows
Since clearing rows is the main mechanic of **Tetris**, here is a place where we can make an interesting change. You can decide what happens when a row is cleared, and decide what it ***really*** means to clear a row.
*/
    func clearFilledRows() {
        var i = 0
        while (i <= Board.MAX_Y) {
            var numBlocks = 0
            for b in blocks {
                if (b.pos.y == i) {
                    numBlocks += 1
                }
            }
            if (numBlocks == Board.MAX_X + 1) {
                clearRow(row: i)
            }
            i += 1
        }
    }
    
    func clearRow(row: Int) {
        var i = 0
        while(i < blocks.count) {
            if (blocks[i].pos.y == row) {
                blocks.remove(at: i)
                i -= 1
            }
            else if (blocks[i].pos.y < row) {
                blocks[i].pos = Pos(x: blocks[i].pos.x, y: blocks[i].pos.y + 1)
            }
            i += 1
        }
    }
/*:
### New Tetra
This is where we go every time a tetra lands and we want to generate a new one. One quick and intersting change we can make here is decrease `UPDATE_TIME` by a small amount each time a new tetra is created, adding difficulty to the game over time.
*/
    func newTetra() {
        var gameOver = false;
        //add tetra to blocks
        for b in tetra.getBlocks() {
            if (b.y < 0) {
                gameOver = true
            }
            else {
                blocks.append(Block(pos: b, color: tetra.color))
            }
        }

        if (gameOver) {
            newGame()
        }
        else {
            clearFilledRows()
            tetra = TETRA_TYPES[Int(arc4random()) % TETRA_TYPES.count]
            tetra.position = Pos(x: 4, y: -1)
            tetra.color = TETRA_COLORS[Int(arc4random()) % TETRA_COLORS.count]
        }
    }
/*:
### New Game
Each time we lose we also have to make sure to start a new game. If there are any new variables you create and want to reset for each game, set them here.
*/
    func newGame() {
        blocks = []
        tetra = Tetra()
        
        newTetra()
    }
/*:
### Drawing
The way we draw in **Tetris** is similar to **Snake**. We simply clear the board, draw the tetra, and then draw the blocks. You can make cool changes here that make the game more exciting visually. Maybe make the the background flash a certain color when a row is cleared? Many visual changes can be made to the game to make losing, moving, or getting a row cleared more impactful and meaningful.
*/
    func draw() {
        clear(color: BACKGROUND_COLOR)
        for pos in tetra.getBlocks() {
            if (pos.x >= 0 && pos.x <= Board.MAX_X && pos.y >= 0 && pos.y <= Board.MAX_Y) {
                cells[pos.x][pos.y] = tetra.color
            }
        }
        for b in blocks {
            cells[b.pos.x][b.pos.y] = b.color
        }
        board.setCells(colors: cells)
    }
    
    func clear(color: UIColor) {
        for x in 0 ... Board.MAX_X {
            for y in 0 ... Board.MAX_Y {
                cells[x][y] = color
            }
        }
    }
}
/*:
# Conclusion
Hopefully you have learned a lot here, because the best way to learn to code is to **ask questions** and **experiment**! The goal of this playground is to inspire those who are learning to code by illustrating the power of code with **Snake** and **Tetris**. As you make more complex changes to these games, they become less like the old time classics they are, and more like new innovative games that you can be proud of because they represent you. So keep **experimenting**, keep **asking questions**, and keep **coding**!!
*/
//:---
//:[< < **Snake** < <](@previous)
//:
//:---
let tetris = Tetris()
PlaygroundPage.current.liveView = tetris.board
