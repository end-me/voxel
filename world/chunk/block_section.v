module chunk

import world.block

struct BlockSection {
	y int
mut:
	blocks []block.Block
}

pub fn (section mut BlockSection) get_block(x, z int) block.Block {
	return section.blocks.filter(it.x == x && it.z == z)[0]
}

pub fn (section mut BlockSection) contains_block(block block.Block) bool {
	for b in section.blocks {
		if b.x == block.x && b.y == block.y && b.z == block.z {
			return true
		}
	}
	return false
}

pub fn (section mut BlockSection) override_block(block block.Block) {
	section.blocks = section.blocks.filter(it.x != block.x && it.y != block.y && it.z != block.z)
	section.blocks << block
}

pub fn (section mut BlockSection) blocks() int {
	return section.blocks.len
}