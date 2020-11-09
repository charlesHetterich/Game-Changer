import UIKit
import PlaygroundSupport
/*:
# Snake
Now that we are familiar with how drawing will work, lets move on to **Snake**. We'll be exploring many different factors we can use to change the game. Some will change the game aesthetically, while others actually raise or lower the difficulty, depending on how they are tweaked. If you're really good, you'll even be able to make changes that will actually change the mechanics of the game!
### Game Constants
We will start off with some simple constants for the game. Try playing around with these values, and notice the changes they make in the game. Just like the first section, `UPDATE_TIME` will change the speed of the program, and as you could probably guess, the other three change the color of the background, snake, and food, respectively.
*/
let UPDATE_TIME = 0.5
let BACKGROUND_COLOR = #colorLiteral(red: 0.8070744821, green: 0.8070744821, blue: 0.8070744821, alpha: 1)
let SNAKE_COLOR = #colorLiteral(red: 0.3579192162, green: 0.7339857817, blue: 0.4819219708, alpha: 1)
let FOOD_COLOR = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
/*:
### Snake Class
Similar to the `Pattern` class from last section, in this section we will be doing most of experimenting in the `Snake` class.
*/
class Snake : UIView {
/*:
### Variables
In addition to `board` and `cells` from last section, we also have `food`, `snake`, `direction`, `lastDirection`, and `ateFood`. You'll see later on in the code why it is essential for to have these new variables. If you want to make a change and need a new member variable, add it here.
*/
    let board = Board()
    var cells : [[UIColor]] = Array(repeating: Array(repeating: BACKGROUND_COLOR, count: Board.MAX_Y + 1), count: Board.MAX_X + 1)
    
    var food : Pos = Pos()
    var snake : [Pos] = []
    var direction : Int = 0
    var lastDirection : Int = 0
    var ateFood = false;
/*:
### Set Up
Here is where we set up our workspace for **Snake**. We call `begin()` so that it is executed right at the beginning of the program, we call the initial `update()` that will call itself every `UPDATE_TIME` seconds, and we set up `swipe()` to hande the user inputs of swiping up, down, left, and right. In `swipe()`, see what happens if you swap `direction = 0` and `direction = 1`. If you did it correctly, you will see that moving left and right get switched.
*/
    init() {
        super.init(frame: .zero)
        begin()
        update()
        //add user input
        for direction : UISwipeGestureRecognizer.Direction in [.left, .right, .up, .down] {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
            gesture.direction = direction
            board.addGestureRecognizer(gesture)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//: >You can see here why we keep track of the variable `lastDirection`. This makes sure that the snake can not turn completely backwards from the last direction it traveled in.
    @objc func swipe(recognizer:UIGestureRecognizer?) {
        guard let recognizer = recognizer as? UISwipeGestureRecognizer else {
            return
        }
        switch recognizer.direction {
        case UISwipeGestureRecognizer.Direction.right:
            direction = 0
        case UISwipeGestureRecognizer.Direction.left:
            direction = 1
        case UISwipeGestureRecognizer.Direction.up:
            direction = 2
        case UISwipeGestureRecognizer.Direction.down:
            direction = 3
        default:
            break
        }
        
        //make sure not to turn backwards
        if (lastDirection == 1 && direction == 0 || lastDirection == 0 && direction == 1 ||
            lastDirection == 3 && direction == 2 || lastDirection == 2 && direction == 3) {
            direction = lastDirection
        }
    }
/*:
### Begin
Since we need to be able to handle a new game when we lose anyway, we have `newGame()`, making `begin()` pretty simple. Feel free to add anything in here that might be necessary (for example, a variable that carries over from game to game might have to be set here, not `newGame()`).
*/
    func begin() {
        newGame()
    }
/*:
### Update
Here is a quick and important lesson for game development. An update function should always go something like this: **[Input -> Move -> Collisions -> Draw]**. Since in this program, the timing of the input function is handled for us, we stick as close to this rule as possible with **[Move snake -> Check for food collisions -> Check for snake collisions -> Draw]**. If there is extra functionality that you come up with to add to the update function, try to maintain this rule with what you do in order to stay organized.
*/
    func update() {
        moveSnake()
        eat()
        
        if (snake.count > 1) {
            checkGameOver()
        }
        
        draw()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + UPDATE_TIME) { self.update() }
    }
/*:
### Move
See what kind of interesting changes you can make in the move function. You'd be suprised how easily you can completely change the mechanics of the game! What if your tail ***always*** grew unless you got food, it ***shrank***? With something as simple as this, you can completely change the meaning and purpose of obtaining food!
*/
    func moveSnake() {
        let oldHead = snake[snake.count - 1]
        lastDirection = direction
        switch direction {
        case 0:
            snake.append(Pos(x: oldHead.x + 1, y: oldHead.y))
        case 1:
            snake.append(Pos(x: oldHead.x - 1, y: oldHead.y))
        case 2:
            snake.append(Pos(x: oldHead.x, y: oldHead.y - 1))
        case 3:
            snake.append(Pos(x: oldHead.x, y: oldHead.y + 1))
        default:
            break
        }

        //keep segments on board
        if (snake[snake.count - 1].x < 0) { snake[snake.count - 1].x += Board.MAX_X + 1 }
        if (snake[snake.count - 1].y < 0) { snake[snake.count - 1].y += Board.MAX_Y + 1 }
        snake[snake.count - 1].x = snake[snake.count - 1].x % (Board.MAX_X + 1)
        snake[snake.count - 1].y = snake[snake.count - 1].y % (Board.MAX_Y + 1)

        //cut tail unless food eaten
        if (!ateFood) { snake.remove(at: 0) }
        ateFood = false
    }
/*:
### Eat
See what kind of interesting changes you can make in the move function. You'd be suprised at how easily you can completely change the mechanics of the game! What if your tail ***always*** grew unless you got food, it ***shrank***? With something as simple as this, you can completely change the meaning and purpose of obtaining food!
*/
    func eat() {
        let head = snake[snake.count - 1]
        if (head.x == food.x && head.y == food.y) {
            food = Pos(x: Int(arc4random()) % (Board.MAX_X + 1),
                       y: Int(arc4random()) % (Board.MAX_Y + 1))
            ateFood = true
        }
    }
/*:
### Game Over
A game over in snake is when the head of the snake runs into another part of the snake's body. Or is it?! You decide! 👾🤖
*/
    func checkGameOver() {
        let head = snake[snake.count - 1]
        for segment in snake[0 ... snake.count - 2] {
            if (head.x == segment.x && head.y == segment.y) {
                newGame()
                break
            }
        }
    }
/*:
### New Game
Right now when we make a new game we just completely reset everything. But perhaps there is something that you would like to carry over from game to game? What if each time the player lost, the next game would start with a snake half of the snakes current size?
*/
    func newGame() {
        food = Pos(x: Int(arc4random()) % (Board.MAX_X + 1),
                   y: Int(arc4random()) % (Board.MAX_Y + 1))
        snake = [Pos(x: Int(arc4random()) % (Board.MAX_X + 1),
                     y: Int(arc4random()) % (Board.MAX_Y + 1))]
        direction = Int(arc4random()) % 4
        ateFood = false
    }
/*:
### Drawing
Here are the `draw()` and `clear()` functions. Most aesthetic changes you might want to make would go here. A rainbow snake? changing background color? Come up with something that would look cool and make it happen!
*/
    func draw() {
        clear(color: BACKGROUND_COLOR)
        for segment in snake { cells[segment.x][segment.y] = SNAKE_COLOR }
        cells[food.x][food.y] = FOOD_COLOR
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
//:---
//:[< < **Patterns** < <](@previous) | [> > **Tetris** > >](@next)
//:
//:---
let snake = Snake()
PlaygroundPage.current.liveView = snake.board
