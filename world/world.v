module world

import world.chunk

struct World {
	name string
	dim Dimension
mut:
	chunks []chunk.Chunk
}

pub fn create_world(name string, dim Dimension) World {
	return World{name, dim}
}

pub fn (world mut World) set_chunk(chunk chunk.Chunk) {
	world.chunks << chunk
}

pub fn (world mut World) get_chunk(x, z int) chunk.Chunk {
	chunk := world.chunks.filter(it.x == x && it.z == z)[0]
	return chunk
}