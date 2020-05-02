module chunk

import world.block
import io

struct ChunkSection {
	y int
mut:
	data []u32
	block_sections []BlockSection
}

pub fn create_chunk_section(y int) ChunkSection {
	return ChunkSection{
		y: y
		data: []u32{}
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

fn (section mut ChunkSection) get_data(bit_per_block byte) []u64{
	len := (16*16*16) * bit_per_block / 64
	mut data := []u64{len: len, cap: len}

	ind_mask := u32((1 << bit_per_block) - 1)

	for y := 0; y < 16; y++ {
		for x := 0; x < 16; x++ {
			for z := 0; z < 16; z++ {
				block_number := (((y * 16) + z) * 16) + x
				start_long := (block_number * bit_per_block) / 64
				start_offset := (block_number * bit_per_block) % 64
				end_long := ((block_number + 1) * bit_per_block - 1) / 64

				mut val := u64(0)

				if section.contains_block_section(y) {
					block_section := section.get_block_section(y)
					block := block_section.get_block(x, z)
					val = block.id
				}

				val &= ind_mask

				data[start_long] |= (val << start_offset)



				if start_long != end_long {
					data[end_long] = (val >> (64 - start_offset))
				}
			}
		}
	}
	return data
}

pub fn (section mut ChunkSection) is_empty() bool {
	return section.block_sections.len <= 0
}

pub fn (section mut ChunkSection) to_buffer() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()
	mut amount := i16(0)
	for block_section in section.block_sections {
		for block in block_section.blocks {
			if block.id > 0 {
				amount += 1
			}
		}
	}
	writer.write_short(amount)
	bit_per_block := byte(14)
	writer.write_byte(bit_per_block)
	data := section.get_data(bit_per_block)
	writer.write_array(data)
	

	return writer.buf
}

pub fn get_block_index(x, y, z int) int {
	return int(y << 8) | int(z << 4) | x
}