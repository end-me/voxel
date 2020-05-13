module handshake

import packet
import io
import net

struct PacketHandshake {
pub mut:
	id int
	len int
	protocol_ver int
	host string
	port i16
	next_state int
}

pub fn (handshake mut PacketHandshake) get_id() int {
	return handshake.id
}

pub fn (handshake mut PacketHandshake) get_len() int {
	return handshake.len
}

pub fn (handshake mut PacketHandshake) from_socket(sock net.Socket) packet.Packet {
	reader, len, pkt_id := packet.read_packet(sock) or {
		error(err)
		return PacketHandshake{}
	}

	protocol_ver := reader.read_pure_var_int()
	host := reader.read_string()
	port := reader.read_short()
	next_state := reader.read_pure_var_int()

	return PacketHandshake{
		id: pkt_id
		len: len
		protocol_ver: protocol_ver
		host: host
		port: port
		next_state: next_state
	}
}

pub fn (handshake mut PacketHandshake) to_buffer() []byte {
	return []byte{}
}