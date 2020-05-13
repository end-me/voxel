module packet

import io
import net

interface Packet {
	get_id() int
	get_len() int
	from_socket(buf []byte) Packet
	to_buffer() []byte
}

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