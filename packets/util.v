module packets

import net
import io

pub fn read_packet(sock net.Socket) ?(io.BufferReader, int, int){
	len_buf, ll := sock.recv(1)
	mut reader := io.create_buf_reader()
	reader.set_buffer(len_buf, ll)
	len := reader.read_pure_var_int()
	if len <= 0 {
		return error('PacketLength is $len')
	}
	buf, l := sock.recv(len)
	reader.set_buffer(buf, l)
	pkt_id := reader.read_pure_var_int()
	return reader, len, pkt_id
}

pub fn parse_next_state(state int) State {
	match state {
		1 {
			return State.Status
		}
		2 {
			return State.Login
		}
		3 {
			return State.Play
		} else {
			return State.Handshake
		}
	}
}

pub fn status_request_string(protocol_ver int, version string, max_player int, online_player int, motd string) string {
	return '{"version":{"name":"$version","protocol":$protocol_ver},"players":{"max":$max_player,"online":$online_player,"sample":[]},"description":{"text":"$motd"}}'
}