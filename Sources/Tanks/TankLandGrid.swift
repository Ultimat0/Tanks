extension TankWorld {


	func gridReport () -> String {
		var gridPrint = " " + String(repeating: "_________ ", count: numberCols) 
		gridPrint += "\n"
		for row in 0..<numberRows {
			for i in 0...3 {
				for col in 0..<numberCols {
					if i == 3 {
						gridPrint += "|_________"
					}
					else if i == 0 {
						if let item = grid[row][col] {
							let energyString = String(item.energy)
							gridPrint += "|"
							gridPrint += energyString
							for _ in 0..<(9-energyString.count) {
								gridPrint += " "
							}
						} else {
							gridPrint += "|         "
						}
					}
					else if i == 1 {
						gridPrint += "|  " + (grid[row][col] == nil ? "     " : grid[row][col]!.name.prefix(5)) + "  "
					}
					else if i == 2 {
						if let item = grid[row][col] {
							gridPrint += "|"
							for _ in 0..<(9-item.position.description.count) {
								gridPrint += " "
							}
							gridPrint += item.position.description
						}
						else {
							gridPrint += "|         "
						}
					}
				}
				gridPrint += "|\n"
			}
		}
		return gridPrint
	}

	func isGoodIndex (row: Int, col: Int) -> Bool {
		return row >= 0 && row < numberRows && col >= 0 && col < numberCols
	}

	func isValidPosition (_ position: Position) -> Bool {
		return isGoodIndex(row: position.row, col: position.col)
	}

	func isPositionEmpty (_ position: Position) -> Bool {
		return grid[position.row][position.col] == nil
	}

	/*func findGameObjectsWithinRange (_ position: Position, range: Int) -> [Position] {
		Wdym by range?????
	}*/

	func findAllTanks() -> [Tank] {
		return findAllGameObjects().filter{$0.objectType == .Tank}.map {$0 as! Tank}
	}

	func findAllRovers() -> [Mine] {
		return findAllGameObjects().filter{$0.objectType == .Mine || $0.objectType == .Rover}.map {$0 as! Mine}
	}

	func containsTank(_ position: Position) -> Bool {
		if let go = grid[position.row][position.col] {
			return go.objectType == .Tank
		}
		return false
	}


	func gameObjectsInRadius (position: Position, radius: Int) -> [GameObject] {
		var gameObjects = [GameObject]()
		for row in (position.row - radius)...(position.row + radius) {
			for col in (position.col - radius)...(position.col + radius) {
				if isGoodIndex(row: row, col: col) {
					if (!isPositionEmpty(Position(row: row, col: col)) && !(col == position.col && row == position.row)) {gameObjects.append(grid[row][col]!)}
				}
			}
		}
		print (gameObjects)
		return gameObjects
	}


}