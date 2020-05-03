module chunk

import world.block
import io
import nbt

struct Chunk {
	x int
	z int
	full_chunk bool
mut:
	sections []ChunkSection
//	height_map_data nbt.Compacter
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

/*fn (chunk mut Chunk) create_heightmap() nbt.NbtCompound {
	compound := nbt.NbtCompound{val: map[string]nbt.Nbt}
	compound.set('MOTION_BLOCKING', nbt.NbtLongArray{val: chunk.height_map_data.values})
	return compound
}*/

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

pub fn (chunk mut Chunk) to_old_buffer() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_int(0)
	writer.write_int(0)
	writer.write_bool(false)
	writer.write_short(0)
	writer.write_var_int(6)
	writer.write_byte(0)
	writer.write_byte(0)
	writer.write_byte(0)
	writer.write_byte(0)
	writer.write_byte(0)
	writer.write_byte(0)

	return writer.flush(0x21)
}

pub fn (chunk mut Chunk) to_buffer() []byte {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_int(chunk.x)
	println('chunkx: ${writer.buf.len}')
	writer.write_int(chunk.z)
	println('chunkz: ${writer.buf.len}')
	writer.write_bool(chunk.full_chunk)
	println('full chunk: ${writer.buf.len}')
	bitmask := chunk.create_bit_mask()
	writer.write_var_int(bitmask)
	println(bitmask)
	println('bitmask: ${writer.buf.len}')
//	heightmap := chunk.create_heightmap()
	writer.write_empty_heightmap()
	println('heightmap: ${writer.buf.len}')

	/*biomes := []int{len: 1024, cap: 1024}

	for biome in biomes {
		writer.write_int(biome)
	}*/
	println('biomes: ${writer.buf.len}')
	writer.write_array([]byte{})
	println('data: ${writer.buf.len}')
	writer.write_var_int(0)
	println('entity: ${writer.buf.len}')

	for b in writer.buf {
		print(int(b))
	}

	return writer.flush(0x22)
}
