module chunk

import io
import nbt

struct ChunkSection {
mut:
	block_count i16
	bit_per_block byte
	blocks []&BlockSection
}

pub fn create_chunk_section(bit_per_block byte) &ChunkSection {
	return &ChunkSection{
		block_count: 0
		bit_per_block: bit_per_block
		blocks: []&BlockSection{cap: 16}
	}
}

pub fn (section mut ChunkSection) init() {
	for y := 0; y < 16; y++ {
		section.blocks << create_block_section()
	}
}

pub fn (section mut ChunkSection) set_block(x, y, z, id int) {
	if section.get_block(x, y, z) > 0 && id <= 0 {
		section.block_count -= 1
	} else {
		section.block_count += 1
	}
	section.blocks[y].set_block(x, z, id)
}

pub fn (section mut ChunkSection) get_block(x, y, z int) int {
	return section.blocks[y].get_block(x, z)
}

pub fn (section mut ChunkSection) write(writer &io.BufferWriter) {
	writer.write_short(4096)
	writer.write_byte(14)

	mut buf := []i64{}
	for block_section in section.blocks {
		buf << block_section.compacter.values
	}

	println(buf.len)

	writer.write_var_int(buf.len)

	for val in buf {
		writer.write_long(val)
	}
}

pub fn (section mut ChunkSection) to_buffer() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()

	//Single data
	writer.write_short(4096)
	writer.write_byte(14)

	mut buf := []i64{}
	for block_section in section.blocks {
		buf << block_section.compacter.values
	}


	writer.write_var_int(buf.len)
	for l in buf {
		writer.write_long(l)
	}

	return writer.buf
}