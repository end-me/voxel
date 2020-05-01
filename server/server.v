module server

import net
import packets
import world

struct Server {
	server net.Socket
	port int
mut:
	world_manager world.WorldManager
	player []Player
	running bool
}

pub fn new(port int) {
	sock := net.listen(port) or { panic(err) }
	mut server := Server{sock, port}
	world_manager := world.create_world_manager(&server)
	server.world_manager = world_manager
	world_manager.create_world('world', world.Dimension.Overworld)
	server.running = true
	server.listen()
}

fn (server mut Server) listen() {
	for server.running {
		mut cont := true
		client := server.server.accept() or {
			error(err)
			continue
		}
		if cont {
			go handle_connection(client, server)
		}
	}
}

pub fn (server mut Server) add_player(play Player) {
	server.player << play
}

pub fn (server mut Server) stop() {
	server.running = false
}