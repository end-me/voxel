module server

import net
import packets
import rand
import io
import time

struct Connection {
	sock net.Socket
mut:
	state packets.State
	udata packets.PacketHandshake
}

pub fn create_connection(sock net.Socket, state packets.State) Connection {
	return Connection{sock, state}
}

pub fn handle_connection(sock net.Socket, server &Server) {
	mut conn := create_connection(sock, packets.State.Handshake)
	handshake_packet := conn.read_handshake()

	conn.udata = handshake_packet

	json := packets.status_request_string(conn.udata.protocol_ver, 'Wrong version', 100, server.player.len, 'Hello from V')

	match handshake_packet.next_state {
		(packets.State.Status) {
			conn.handle_status(json)
		}
		(packets.State.Login) {
			conn.handle_login(server, conn.udata.protocol_ver)
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

fn (conn mut Connection) handle_login(server &Server, protocol_ver int) {
	rand.seed(time.now().unix)
	login_start := conn.read_login_start()<

	conn.write_login_succesful('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', login_start.name)
	name := login_start.name
	uuid := 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
	entity_id := rand.next(10)
	mut player := Player{
		name: name
		uuid: uuid
		entity_id: entity_id
		conn: &conn
	}
	server.add_player(player)
	player.conn.state = packets.State.Play
	conn.write_join_game(entity_id, 0)

	for {
		reader, len, pkt_id := packets.read_packet(conn.sock) or { break }
		conn.handle_play_packet(reader, len, pkt_id, player, server, protocol_ver)
	}
}

fn (conn mut Connection) handle_play_packet(reader io.BufferReader, len int, pkt_id int, player Player, server &Server, protocol_ver int) {
	println('Received play packet 0x$pkt_id with len of $len')
	match pkt_id {
		5 {
			conn.write_chunk(0, 0, server, protocol_ver)
			conn.write_held_item_change()
		}
		else {
			println('Something went wrong with $pkt_id')
		}
	}
}