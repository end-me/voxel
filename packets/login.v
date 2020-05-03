module packets

import io
import server

pub fn (conn mut server.Connection) read_login_start() PacketLoginStart {
	reader, len, pkt_id := read_packet(conn.sock) or {
		error(err)
		return PacketLoginStart{}
	}
	name := reader.read_string()
	packet := PacketLoginStart{
		len: len
		pkt_id: pkt_id
		name: name
	}
	return packet
}

pub fn (conn mut server.Connection) write_login_succesful(uuid string, username string) {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_string(uuid)
	writer.write_string(username)

	buf := writer.flush(2)
	conn.sock.send(buf.data, buf.len) or { panic(err) }
}