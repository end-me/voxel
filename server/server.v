module server

import net
import packets

struct Server {
	server net.Socket
	port int
mut:
	player []Player
	running bool
}

pub fn new(port int) {
	sock := net.listen(port) or { panic(err) }
	mut server := Server{sock, port}
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