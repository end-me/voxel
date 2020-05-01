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
	block_sections []BlockSection
}

struct BlockSection {
	y int
mut:
	blocks []block.Block
}

pub fn create_chunk_section(y int) ChunkSection {
	return ChunkSection{
		y: y
		block_sections: []BlockSection{}
	}
}

pub fn (section mut ChunkSection) set_block(block block.Block) {
	mut block_section := BlockSection{
		y: block.y
		blocks: []block.Block{}
	}
	if section.contains_block_section(block.y) {
		block_section = section.get_block_section(block.y)
	}
	if block_section.contains_block(block) {
		block_section.override_block(block)
	} else {
		block_section.blocks << block
	}
	section.override_block_section(block_section)
}

pub fn (section mut ChunkSection) get_block_section(y int) BlockSection {
	return section.block_sections.filter(it.y == y)[0]
}

pub fn (section mut ChunkSection) contains_block_section(y int) bool {
	for block_section in section.block_sections {
		if block_section.y == y {
			return true
		}
	}
	return false
}

pub fn (section mut ChunkSection) override_block_section(block_section BlockSection) {
	section.block_sections = section.block_sections.filter(it.y != block_section.y)
	section.block_sections << block_section
}

pub fn (section mut BlockSection) get_block(x, y, z int) block.Block {
	return section.blocks.filter(it.x == x && it.y == y && it.z == z)[0]
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

pub fn (section mut ChunkSection) is_empty() bool {
	return section.block_sections.len <= 0
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

pub fn (chunk mut Chunk) contains_section(y int) bool {
	for chunk_section in chunk.sections {
		if chunk_section.y == y {
			return true
		}
	}
	return false
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

pub fn (chunk mut Chunk) create_heightmap() []byte {
	mut buf := []byte{
		len: 272,
		cap: 256
	}
	for cy := 0; cy < chunk.sections.len; cy++ {
		if chunk.contains_section(cy) {
			section := chunk.get_section(cy)
			for y := 0; y < 15; y++ {
				if section.contains_block_section(y) {
					block_section := section.get_block_section(y)
					for block in block_section.blocks {
						height_index := block.z * 16 + block.x
						if buf[height_index] < block.y {
							buf[height_index] = block.y + 1
						}
					}
				}
			}
		}
	}
	return buf
}

pub fn (section mut ChunkSection) to_buffer() []byte {
	return []byte{}
}

pub fn (chunk mut Chunk) to_buffer() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_int(chunk.x)
	writer.write_int(chunk.z)
	writer.write_bool(chunk.full_chunk)
	writer.write_var_int(chunk.create_bit_mask())
	writer.write(chunk.create_heightmap())
	writer.write_int(0)

	return writer.flush(22)
}
