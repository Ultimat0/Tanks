class Mine: GameObject {
	
	init (row: Int, col: Int, energy: Int, id: String) {
		super.init(row: row, col: col, objectType: .Mine, energy: energy, id: id)
	}
}