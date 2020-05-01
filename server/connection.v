module server

import net
import packets

struct Connection {
	sock net.Socket
	state packets.State
}

pub fn create_connection(sock net.Socket, state packets.State) Connection {
	return Connection{sock, state}
}

pub fn handle_connection(sock net.Socket, server &Server) {
	conn := create_connection(sock, packets.State.Handshake)
}