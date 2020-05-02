module block

import io

struct Block {
mut:
	x int
	y int
	z int
	id i16
	subid byte
}

pub fn create_block(x, y, z int, id i16, subid byte) Block {
	return Block{
		x: x
		y: y
		z: z
		id: id
		subid: subid
	}
}

pub fn (block mut Block) to_data() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_short(block.id)
	writer.write_byte(block.subid)
	return writer.to_buffer()
}