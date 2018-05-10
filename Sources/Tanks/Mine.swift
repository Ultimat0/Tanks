class Mine: GameObject {
	
	init (row: Int, col: Int, name: String, energy: Int, id: String) {
		super.init(row: row, col: col, objectType: .Mine, name: name, energy: energy, id: id)
	}
}