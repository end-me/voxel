module server

import net
import packets

struct Connection {
	sock net.Socket
	state packets.State
mut:
	udata packets.PacketHandshake
}

pub fn create_connection(sock net.Socket, state packets.State) Connection {
	return Connection{sock, state}
}

pub fn handle_connection(sock net.Socket, server &Server) {
	mut conn := create_connection(sock, packets.State.Handshake)
	handshake_packet := conn.read_handshake()

	conn.udata = handshake_packet

	json := packets.status_request_string(conn.udata.protocol_ver, 'Wrong version', 100, -0, 'Hello from V')

	match handshake_packet.next_state {
		(packets.State.Status) {
			conn.handle_status(json)
		}
		(packets.State.Login) {
			conn.handle_login()
		}
		else {
			println('Something went wrong')
		}
	}
}

fn (conn mut Connection) handle_status(json string) {
	status_request := conn.read_status_request()
	if status_request.pkt_id == 0 && status_request.len == 1 {
		conn.write_status_response(json)
	} else {
		//TODO error handling
	}

	status_ping := conn.read_status_ping()
	conn.write_status_pong(status_ping.payload)
}

fn (conn mut Connection) handle_login() {
	login_start := conn.read_login_start()

	conn.write_login_succesful('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', login_start.name)
}

fn (conn mut Connection) handle_play() {

}