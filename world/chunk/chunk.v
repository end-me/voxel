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

fn (chunk mut Chunk) create_heightmap() []byte {
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

fn (chunk mut Chunk) create_data_array() []byte {
	mut b := []byte{
		len: 16,
		cap: 16
	}
	for y := 0; y < 16; y++ {
		if chunk.contains_section(y) {
			section := chunk.get_section(y)
			buffer := section.to_buffer()
			b << buffer
		}
	}
	return b
}

pub fn (chunk mut Chunk) to_buffer() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_int(chunk.x)
	writer.write_int(chunk.z)
	writer.write_bool(chunk.full_chunk)
	writer.write_var_int(0)
	writer.write(chunk.create_heightmap())
	writer.write_int(0)
	writer.write_array(chunk.create_data_array())
	writer.write_byte(0)

	return writer.flush(0x22)
}
