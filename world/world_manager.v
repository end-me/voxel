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
	world_chunk := chunk.create_chunk(0, 0, false)
	for i := 0; i < 16; i++ {
		chunk_section := chunk.create_chunk_section(i)
		world_chunk.set_section(chunk_section)
	}
	
	world.set_chunk(world_chunk)
	man.add_world(world)
}