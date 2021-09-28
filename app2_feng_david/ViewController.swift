//
//  ViewController.swift
//  app2_feng_david
//
//  Created by David Feng on 9/17/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    struct Scores {
        var playerOneScore = 0
        var playerTwoScore = 0
    }
    
    var score = Scores()
    
    // true when it is player one's turn; false when it is player 2's turn
    var playerOneTurn = true
    var gameFinished = false

    
    // keeps track of the game's state through a 1D representation of the matrx. 0 if the cell is not clicked. 1 if player 1 clicked. 2 if player 2 clicked
    var gameBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    

    // these are references to the labels in the game
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    @IBOutlet weak var status: UILabel!
    
    let winningCombos = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [2, 4, 6], [0, 4, 8]]
    
    // this collection refers to all 9 buttons
    @IBOutlet var collectionOfButtons: Array<UIButton>?
    
    // this function returns true if there is a draw; returns false otherwise
    func checkDraw() -> Bool {
        for val in gameBoard {
            if (val == 0) {
                return false
            }
        }
        for playerNumber in 1...2 {
            for combo in winningCombos {
                if (gameBoard[combo[0]] == playerNumber && gameBoard[combo[1]] == playerNumber && gameBoard[combo[2]] == playerNumber) {
                    return false
                }
            }
        }
        return true
    }
    
    // this handles the changing of the image on each of the 9 buttons
    @IBAction func buttonClick(_ sender: UIButton) {
        
        if (!gameFinished) {
            
            // checks if user clicked on button that is marked empty
            if gameBoard[sender.tag] == 0 {
                if playerOneTurn {
                    sender.setImage(UIImage(named:"mark-x"), for: .normal)
                    gameBoard[sender.tag] = 1
                } else {
                    sender.setImage(UIImage(named:"mark-o"), for: .normal)
                    gameBoard[sender.tag] = 2
                }
                
                // checks if the game is won
                var idCheck = 0
                var winningMarker = ""
                if playerOneTurn {
                    idCheck = 1
                    winningMarker = "mark-x"
                } else {
                    idCheck = 2
                    winningMarker = "mark-o"
                }
                
                for combo in winningCombos{
                    // check if that combination wins the game
                    
                    if (gameBoard[combo[0]] == idCheck && gameBoard[combo[1]] == idCheck && gameBoard[combo[2]] == idCheck) {
                        
                        let buttonImage = UIImage(named: winningMarker)?.withRenderingMode(.alwaysTemplate)
                        
                        for cell in collectionOfButtons! {
                            if (cell.tag == combo[0] || cell.tag == combo[1] || cell.tag == combo[2]) {
                                cell.setImage(buttonImage, for: .normal)
                                cell.tintColor = .systemYellow
                            }
                            
                        }

                        // game should be won and status check should change
                        gameFinished = true
                        status.text = "Player \(idCheck) Wins!"
                        status.textColor = UIColor.systemGreen
                        
                        if (idCheck == 1) {
                            score.playerOneScore = score.playerOneScore + 1
                            player1.text = "Player 1 Score: \(score.playerOneScore)"
                        } else {
                            score.playerTwoScore = score.playerTwoScore + 1
                            player2.text = "Player 2 Score: \(score.playerTwoScore)"
                        }
                        break
                        
                    }
                        
                }
                
                if (checkDraw()) {
                    gameFinished = true
                    for cell in collectionOfButtons! {
                        if (gameBoard[cell.tag]) == 1 {
                            winningMarker = "mark-x"
                        } else {
                            winningMarker = "mark-o"
                        }
                        let buttonImage = UIImage(named: winningMarker)?.withRenderingMode(.alwaysTemplate)
                        cell.setImage(buttonImage, for: .normal)
                        cell.tintColor = .systemGray
                    }
                    status.text = "It's a draw!"
                    status.textColor = UIColor.darkGray
                }
                
                if (!gameFinished) {
                    // switches turn!
                    playerOneTurn = !playerOneTurn
                    if playerOneTurn {
                        status.text = "Player 1's Turn"
                    } else {
                        status.text = "Player 2's Turn"
                    }
                }
                
            }
        }
        
    }
    
    // clears the game board
    @IBAction func clear(_ sender: UIButton) {
        
        gameBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        playerOneTurn = true
        gameFinished = false
        
        for button in collectionOfButtons! {
            button.setImage(UIImage(named: "mark-none"), for: .normal)
        }
        
        status.text = "Player 1's Turn"
        status.textColor = UIColor.black
        print("Clear button pressed!")
    }
    
}

