module packets

struct Packet {
	len int
	pkt_id int
}

struct PacketHandshake {
	len int
	pkt_id int
	protocol_ver int
	host string
	port i16
	next_state State
}

struct PacketStatusRequest {
	len int
	pkt_id int
}

struct PacketStatusPing {
	len int
	pkt_id int
	payload int
}

struct PacketLoginStart {
	len int
	pkt_id int
	name string
}