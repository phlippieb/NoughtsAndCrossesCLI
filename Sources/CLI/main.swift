// Main loop

var shouldContinue = true

let game: GameType = Game()

while shouldContinue {
    print(game.getNextMessage())

    guard let line = readLine() else {
        shouldContinue = false
        continue
    }

    if line == ":q" {
       shouldContinue = false

    } else {
        game.process(input: line)
    }
}

