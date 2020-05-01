module world

import server
import world.chunk
import world.block

struct WorldManager {
	server &server.Server
mut:
	worlds map[string]World
}

pub fn create_world_manager(server &server.Server) WorldManager {
	return WorldManager{server}
}

pub fn (man mut WorldManager) add_world(world World) {
	man.worlds[world.name] = world
}

pub fn (man mut WorldManager) get_world(name string) ?World {
	if !man.contains_world(name) {
		return error('World doesn\'t exists')
	}
	return man.worlds[name]
}

pub fn (man mut WorldManager) contains_world(name string) bool {
	return name in man.worlds
}

pub fn (man mut WorldManager) create_world(name string, dim Dimension) {
	world := create_world(name, dim)

	world_chunk := chunk.create_chunk(0, 0, true)

	for i := 1; i < 16; i++ {
		chunk_section := chunk.create_chunk_section(i)
		world_chunk.set_section(chunk_section)
	}

	section := chunk.create_chunk_section(0)

	for x := 0; x < 16; x++ {
		for z := 0; z < 16; z++ {
			block := block.create_block(x, 0, z, 1)
			section.set_block(block)
		}
	}

	world_chunk.set_section(section)

	world.set_chunk(world_chunk)

	world_chunk.to_buffer()

	man.add_world(world)
}