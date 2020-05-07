module world

enum Dimension {
	Nether
	Overworld
	End
}

pub fn (dim Dimension) to_int() int {
	match dim {
		.Nether {
			return -1
		}
		.Overworld {
			return 0
		}
		.End {
			return 1
		}
	}
	return 0
}