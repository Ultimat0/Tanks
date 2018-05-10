class Rover: GameObject {
	let direction: Direction?

	init (direction: Direction?, row: Int, col: Int, name: String, energy: Int, id: String) {
		self.direction = direction
		super.init(row: row, col: col, objectType: .Rover, name: name, energy: energy, id: id)
	}
}