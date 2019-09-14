protocol GameType {
    func process(input: String)
    func getNextMessage() -> String
}

import GameEngine

class Game {
    private lazy var store = MainStore()
}

extension Game: GameType {
    func getNextMessage() -> String {
        var message = ""
        self.store.state.map { state in
            message += self.getMessage(for: state)
        }
        message += "Enter :q to quit."
        return message
    }
}

// Actual implementation :)

extension Game {
    private func getMessage(for state: AppState) -> String {
        switch state.gameState {
        case .playing(let playingState): return self.getMessage(for: playingState)
        case .finished(let finishedState): return self.getMessage(for: finishedState)
        }
    }

    private func getMessage(for playingState: PlayingState) -> String {
        return self.getBoardMessage(for: playingState)
            + self.getCurrentPlayerMessage(for: playingState)
            + self.getOptionsMessage()
    }

    private func getBoardMessage(for playingState: PlayingState) -> String {
        var message = ""

        // Print the board:

        for (i, cell) in playingState.board.enumerated() {
            if (i > 0 && i % 3 == 0) {
                message += "\n"
            }

            switch cell {
            case .none: message += "_"
            case .some(.nought): message += "0"
            case .some(.cross): message += "X"
            }
        }

        message += "\n"
        return message
    }

    private func getCurrentPlayerMessage(for playingState: PlayingState) -> String {
        switch playingState.playerTurn {
        case .nought: return "Noughts' turn.\n"
        case .cross: return "Crosses' turn.\n"
        }
    }

    private func getOptionsMessage() -> String {
        return "Enter a number from 0-9 to place a piece.\n"
    }

    private func getMessage(for finishedState: FinishedState) -> String {
        return self.getResultsMessage(for: finishedState)
            + "Enter anything to play again.\n"
    }

    private func getResultsMessage(for finishedState: FinishedState) -> String {
        switch finishedState.winner {
        case .none: return "It's a draw!\n"
        case .some(.nought): return "Noughts win!\n"
        case .some(.cross): return "Crosses win!\n"
        }
    }
}

extension Game {
    func process(input: String) {
        guard let state = self.store.state else { return }
        switch state.gameState {
        case .playing:
            guard let number = Int(input),
                0...8 ~= number
                else {
                    print("Invalid input")
                    return
                }

            self.store.dispatch(PlacePieceAction(at: number))

        case .finished:
            store.dispatch(RestartGameAction())
        }
    }
}

