import UIKit
import PlaygroundSupport
/*: 
# Hello Game Changer!
In this playground, we will be exploring two world famous games: **Snake** and **Tetris**, seeing what kinds of changes we can make with the power of code!
 
For starters, let's familarize ourselves with how to work with this playground with a simple example of drawing on the board.

### Update Time
First thing we want to do is define how frequently this board gets updated. `UPDATE_TIME` represents this value in seconds. Try playing around with the value and notice the changes made when you increase or decrease it.
*/
let UPDATE_TIME = 0.5
/*:
### Pattern Class
Mostly everything we will be doing in this first section will be in this `Pattern` class. This is where we access and edit the values of the board. You will see that there are values and functions that we can play around with in order to get new interesting visuals going on in the view.
 */
class Pattern : UIView {
/*:
### Variables
Here is where we will define the member variables used by the class. Feel free to change or add variables that you think might be useful or interesting!
*/
    //keeps track of how many updates have occured
    var timer = 0
    
    //the board that we will be drawing on
    let board = Board()
    
    //the colors that we will set the board to
    var cells : [[UIColor]] = Array(repeating: Array(repeating: #colorLiteral(red: 0.8070744821, green: 0.8070744821, blue: 0.8070744821, alpha: 1), count: Board.MAX_Y + 1), count: Board.MAX_X + 1)
/*:
### Initialization
Every class needs to be initialized. Here is where our initializer, `init()`, is written. Note that we make sure to call `begin()` and the initial `update()` which will call itself every `UPDATE_TIME` seconds.
*/
    init() {
        super.init(frame: .zero)
        
        begin()
        update()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
/*:
### Begin
This is the begin function. Since we call `begin()` in our `init()` function, this function will be called once right when a Pattern object is created. Feel free to add any code here to initialize the board or some variables.
*/
    func begin() {
        
    }
/*:
### Update
This is the update function, where the real action happens. To make the visuals constantly change, we will use the update function to manipulate the board. Try changing things around in here to see what kinds of effects you can get. Note that we have access to some helper functions `verticleLineOf()`, `horizontalLineOf()`, `clear()`, and `greetingOf()`. So explore! What happens if you remove the clear function? What happens if you draw two crossing lines of different colors? Which one will be on top? What other questions can you come up with?
*/
    func update() {
        clear(color: #colorLiteral(red: 0.8070744821, green: 0.8070744821, blue: 0.8070744821, alpha: 1))
        greetingOf(color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), fromTop: 7, fromLeft: Board.MAX_X + 1 - timer % 30)
        horizontalLineOf(color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), fromTop:  5)
        horizontalLineOf(color: #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), fromTop: 13)

        timer += 1
        board.setCells(colors: cells)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + UPDATE_TIME) { self.update() }
    }
/*:
### Verticle Line
Draws a verticle line with a given color and x position
*/
    func verticleLineOf(color: UIColor, fromLeft: Int) {
        if (fromLeft >= 0 && fromLeft <= Board.MAX_X) {
            for y in 0 ... Board.MAX_Y {
                cells[fromLeft][y] = color
            }
        }
    }
/*:
### Horizontal Line
Draws a horizontal line with a given color and y position
*/
    func horizontalLineOf(color: UIColor, fromTop: Int) {
        if (fromTop >= 0 && fromTop <= Board.MAX_Y) {
            for x in 0 ... Board.MAX_X {
                cells[x][fromTop] = color
            }
        }
    }
/*:
### Clear
Clears the entire board with a given color
*/
    func clear(color: UIColor) {
        for x in 0 ... Board.MAX_X {
            for y in 0 ... Board.MAX_Y {
                cells[x][y] = color
            }
        }
    }
/*:
### Greeting
Check it out, maybe this is kind of how bitmap images are created and displayed? 🤔🤔
*/
        func greetingOf(color: UIColor, fromTop: Int, fromLeft: Int) {
        //create the letters of "HELLO"
        let letters = [[[1, 0, 1],  //H
                        [1, 0, 1],
                        [1, 1, 1],
                        [1, 0, 1],
                        [1, 0, 1]],
                       
                       [[1, 1, 1],   //E
                        [1, 0, 0],
                        [1, 1, 1],
                        [1, 0, 0],
                        [1, 1, 1]],
                       
                       [[1, 0, 0],   //L
                        [1, 0, 0],
                        [1, 0, 0],
                        [1, 0, 0],
                        [1, 1, 1]],
                       
                       [[1, 0, 0],   //L
                        [1, 0, 0],
                        [1, 0, 0],
                        [1, 0, 0],
                        [1, 1, 1]],
                       
                       [[1, 1, 1],   //O
                        [1, 0, 1],
                        [1, 0, 1],
                        [1, 0, 1],
                        [1, 1, 1]]]
        
        let numLetters = letters.count
        let letterHeight = letters[0].count
        let letterWidth = letters[0][0].count
        
        //draw the letters
        for l in 0 ... numLetters - 1 {
            for x in 0 ... letterWidth - 1 {
                for y in 0 ... letterHeight - 1 {
                    let xPos = x + l * (letterWidth + 1) + fromLeft
                    let yPos = y + fromTop
                    if (xPos >= 0 && xPos <= Board.MAX_X && yPos >= 0 && yPos <= Board.MAX_Y) {
                        if (letters[l][y][x] == 1) {
                            cells[xPos][yPos] = color
                        }
                    }
                }
            }
        }
    }
}
//:---
//: [> > **Snake** > >](@next)
//:
//:---
let pattern = Pattern()
PlaygroundPage.current.liveView = pattern.board
