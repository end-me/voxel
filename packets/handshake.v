module packets

import server

pub fn (conn mut server.Connection) read_handshake() PacketHandshake {
	reader, len, pkt_id := read_packet(conn.sock) or {
		error(err)
		return PacketHandshake{}
	}

	//Read Data
	protocol_ver := reader.read_pure_var_int()
	host := reader.read_string()
	port := reader.read_short()
	next_state := reader.read_pure_var_int()

	state := parse_next_state(next_state)

	packet := PacketHandshake{
		len: len
		pkt_id: pkt_id
		protocol_ver: protocol_ver
		host: host
		port: port
		next_state: state
	}

	return packet
}