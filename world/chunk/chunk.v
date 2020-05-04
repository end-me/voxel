module chunk

import io
import nbt

struct Chunk {
	chunk_x int
	chunk_z int
	full_chunk bool
mut:
	primary_bit_mask int
	heightmap nbt.NbtCompound
	biomes []int
	sections []&ChunkSection
}

pub fn create_chunk(chunk_x, chunk_z int, full_chunk bool) &Chunk {
	return &Chunk{
		chunk_x: chunk_x
		chunk_z: chunk_z
		full_chunk: full_chunk
		primary_bit_mask: 0
		biomes: []int{len: 16*16, cap: 16*16, default: 1}
		sections: []&ChunkSection{len: 16}
	}
}

pub fn (chunk mut Chunk) init() {
	for y := 0; y < 16; y++ {
		section := create_chunk_section(14)
		chunk.sections << section
		section.init()
	}
}

pub fn (chunk mut Chunk) set_block(x, y, z, id int) {
	chunk_y, block_y := convert_chunk_y(y)
	section := chunk.sections[chunk_y]
	if id > 0 && section.block_count <= 0 {
		chunk.primary_bit_mask |= 1 << chunk_y
	} else {
		chunk.primary_bit_mask ^= 1 << chunk_y
	}
	section.set_block(x, block_y, z, id)
}

pub fn (chunk mut Chunk) get_block(x, y, z int) int {
	chunk_y, block_y := convert_chunk_y(y)
	section := chunk.sections[chunk_y]
	return section.get_block(x, block_y, z)
}

pub fn convert_chunk_y(y int) (int, int) {
	chunk := int(y / 16)
	y_in_chunk := y % 16
	return chunk, y_in_chunk
}