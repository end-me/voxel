module block

struct Block {
mut:
	x int
	y int
	z int
	id int
}

pub fn create_block(x, y, z, id int) Block {
	return Block{
		x: x
		y: y
		z: z
		id: id
	}
}