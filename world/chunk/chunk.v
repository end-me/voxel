module chunk

import io
import nbt

struct Chunk {
	chunk_x int
	chunk_z int
	full_chunk bool
mut:
	primary_bit_mask int
	heightmap nbt.Compacter
	biomes []int
	sections []&ChunkSection
}

pub fn create_chunk(chunk_x, chunk_z int, full_chunk bool) &Chunk {
	return &Chunk{
		chunk_x: chunk_x
		chunk_z: chunk_z
		full_chunk: full_chunk
		primary_bit_mask: 0
		heightmap: nbt.create_new_compacter(9, 256)
		biomes: []int{len: 16*16, cap: 16*16, default: 1}
		sections: []&ChunkSection{cap: 16}
	}
}

pub fn (chunk mut &Chunk) init() {
	for y := 0; y < 16; y++ {
		section := create_chunk_section(14)
		chunk.sections << section
		section.init()
	}
}

pub fn (chunk mut Chunk) set_block(x, y, z, id int) {
	/*chunk_y, block_y := convert_chunk_y(y)
	section := chunk.sections[chunk_y]
	if id > 0 && section.block_count <= 0 {
		chunk.primary_bit_mask |= 1 << chunk_y
	} else {
		chunk.primary_bit_mask ^= 1 << chunk_y
	}
	section.set_block(x, block_y, z, id)*/
}

pub fn (chunk mut Chunk) get_block(x, y, z int) int {
	/*chunk_y, block_y := convert_chunk_y(y)
	section := chunk.sections[chunk_y]
	return section.get_block(x, block_y, z)*/
	return 0
}

pub fn (chunk mut Chunk) get_heightmap() nbt.NbtCompound {
	mut compound := nbt.NbtCompound{
		val: map[string]nbt.Nbt
	}
	compound.set('MOTION_BLOCKING', nbt.NbtLongArray{
		val: chunk.heightmap.values
	})
	return compound
}

pub fn convert_chunk_y(y int) (int, int) {
	chunk := int(y / 16)
	y_in_chunk := y % 16
	return chunk, y_in_chunk
}

pub fn (chunk mut Chunk) to_buffer() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()

	//Simple parameter
	writer.write_int(chunk.chunk_x)
	writer.write_int(chunk.chunk_z)
	writer.write_bool(chunk.full_chunk)

	//Bits
	writer.write_var_int(0)
	writer.write_nbt(chunk.get_heightmap())

	//Biome
	for biome in chunk.biomes {
		writer.write_int(biome)
	}

	mut data_buf := []byte{}
	for section in chunk.sections {
		b := section.to_buffer()
		data_buf << b
	}

	writer.write_var_int(data_buf.len)
	for b in data_buf {
		writer.write_byte(b)
	}
	writer.write_var_int(0)
	
	return writer.flush(0x22)
}