class Rover: GameObject {
	let direction: Direction?

	init (direction: Direction?, row: Int, col: Int, energy: Int, id: String) {
		self.direction = direction
		super.init(row: row, col: col, objectType: .Rover, energy: energy, id: id)
	}
}