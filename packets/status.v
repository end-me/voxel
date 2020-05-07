module packets

import server
import io

pub fn (conn mut server.Connection) read_status_request() PacketStatusRequest {
	_, len, pkt_id := read_packet(conn.sock) or {
		error(err)
		return PacketStatusRequest{}
	}
	packet := PacketStatusRequest{
		len: len
		pkt_id: pkt_id
	}
	return packet
}

pub fn (conn mut server.Connection) read_status_ping() PacketStatusPing {
	reader, len, pkt_id := read_packet(conn.sock) or {
		error(err)
		return PacketStatusPing{}
	}
	payload := reader.read_long()

	packet := PacketStatusPing{
		len: len
		pkt_id: pkt_id
		payload: payload
	}
	return packet
}

pub fn (conn mut server.Connection) write_status_response(json string) {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_string(json)

	buf := writer.flush(0)


	conn.sock.send(buf.data, buf.len) or { panic(err) }
}

pub fn (conn mut server.Connection) write_status_pong(payload u64) {
	writer := io.create_buf_writer()
	writer.create_empty()
	println(payload)
	writer.write_ulong(payload)

	buf := writer.flush(1)
	conn.sock.send(buf.data, buf.len) or { panic(err) }
}