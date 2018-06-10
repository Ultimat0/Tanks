import Foundation

public class TankWorld {
	
	var grid: [[GameObject?]]
	var turn: Int = 0
	var gameOver = false
	let numberCols = 10
	let numberRows = 10
	var numberLivingTanks = 0
	var lastLivingTank: Tank? = nil
	let constants: Constants = Constants()

	init () {

		grid = Array(repeating: Array(repeating: nil, count: numberCols), count: numberRows)
		srandom(UInt32(time(nil)))

	}

	func setWinner(lastTankStanding: Tank) {
		gameOver = true
		lastLivingTank = lastTankStanding
	}

	func populateTankWorld () {
		addGameObject(gameObject: Tank(row: 5, col: 5, energy: 100000, id: "CLAP", instructions: ""))
		addGameObject(gameObject: Tank(row: 5, col: 9, energy: 100000, id: "OPOP", instructions: ""))
		/*addGameObject(gameObject: Tank(row: 8, col: 8, name: "Cancer", energy: 100000, id: "AID", instructions: ""))
		addGameObject(gameObject: Mine(row: 3, col: 5, name: "MrMine", energy: 4000, id: "MIN"))
		addGameObject(gameObject: Rover(direction: nil, row: 4, col: 5, name: "RoverMan", energy: 5000, id: "ROV"))
		addGameObject(gameObject: Rover(direction: nil, row: 6, col: 9, name: "RoverMan", energy: 5000, id: "ROV"))
		addGameObject(gameObject: Rover(direction: nil, row: 0, col: 0, name: "RoverMan", energy: 5000, id: "ROV"))
		addGameObject(gameObject: Rover(direction: nil, row: 9, col: 9, name: "RoverMan", energy: 5000, id: "ROV"))
		addGameObject(gameObject: Rover(direction: nil, row: 5, col: 7, name: "RoverMan", energy: 5000, id: "ROV"))*/

	}

	func addGameObject (gameObject: GameObject) {
		//logger.addMajorLog(gameObject, "Added to TankLand")
		grid[gameObject.position.row] [gameObject.position.col] = gameObject
		if gameObject.objectType == .Tank {numberLivingTanks += 1}
	}

	
	func doTurn() {
		var allObjects = findAllGameObjects()
		print (allObjects)
		randomizeGameObjects(&allObjects)
		print (allObjects)

		for gameObject in allObjects {
			switch gameObject.objectType {
				case .Tank: handleTankPre(tank: (gameObject as! Tank))
				case .Rover: handleRoverPre(rover: gameObject as! Rover)
				case .Mine: print("Mine Pre")
			}
		}

		for gameObject in allObjects {
			switch gameObject.objectType {
				case .Tank: handleTankPost(tank: (gameObject as! Tank))
				case .Rover: handleRoverPost(rover: gameObject as! Rover)
				case .Mine: print("Mine Post")
			}
		}
		
		turn += 1
	}

	func runOneTurn() {
		doTurn()
		print(gridReport())
	}

	func driver() {
		populateTankWorld()
		print(gridReport())
		/*while !gameOver {
			runOneTurn()
		}*/
		for _ in 0..<1 {
			runOneTurn()
		}
	}
}