module chunk

import nbt

struct BlockSection {
mut:
	compacter &nbt.Compacter
}

pub fn create_block_section() &BlockSection {
	return &BlockSection{nbt.create_new_compacter(14, 256)}
}

pub fn (block_s mut BlockSection) set_block(x, z, id int) {
	block_s.compacter.set(z*16+x, id)
}

pub fn (block_s BlockSection) get_block(x, z int) i64 {
	return block_s.compacter.get(z*16+x)
}