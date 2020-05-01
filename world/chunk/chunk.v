module chunk

import world.block
import io

struct Chunk {
	x int
	z int
	full_chunk bool
mut:
	sections []ChunkSection
}

struct ChunkSection {
	y int
mut:
	blocks []block.Block
}

pub fn create_chunk_section(y int) ChunkSection {
	return ChunkSection{y}
}

pub fn (section mut ChunkSection) set_block(block block.Block) {
	section.blocks << block
}

pub fn (section mut ChunkSection) get_block(x, y, z int) block.Block {
	return section.blocks.filter(it.x == x && it.y == y && it.z == z)[0]
}

pub fn (section mut ChunkSection) is_empty() bool {
	return section.blocks.len <= 0
}

pub fn create_chunk(x, z int, full_chunk bool) Chunk {
	return Chunk{x, z, full_chunk}
}

pub fn (chunk mut Chunk) set_section(section ChunkSection) {
	chunk.sections << section
}

pub fn (chunk mut Chunk) get_section(y int) ChunkSection {
	return chunk.sections.filter(it.y == y)[0]
}

fn (chunk mut Chunk) create_bit_mask() int {
	mut bitmask := 0
	for y := 0; y < chunk.sections.len; y++ {
		section := chunk.get_section(y)
		if !section.is_empty() {
			bitmask |= 1 << y
		}
	}
	return bitmask
}

pub fn (section mut ChunkSection) to_buffer() []byte {
	
}

pub fn (chunk mut Chunk) to_buffer() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_int(chunk.x)
	writer.write_int(chunk.z)
	writer.write_bool(chunk.full_chunk)
	writer.write_var_int(chunk.create_bit_mask())

	return writer.flush(22)
}
