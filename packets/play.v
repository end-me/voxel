module packets

import server
import io

pub fn (conn mut server.Connection) write_join_game(entity_id int, gamemode byte) {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_int(entity_id)
	writer.write_byte(gamemode)
	writer.write_int(0) //TODO position and world
	writer.write_long(10)
	writer.write_byte(100)
	writer.write_string('default')
	writer.write_var_int(16) //
	writer.write_bool(false)
	writer.write_bool(false)

	buf := writer.flush(0x26)
	conn.sock.send(buf.data, buf.len) or { panic(err) }
}

pub fn (conn mut server.Connection) write_held_item_change() {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_byte(0)

	buf := writer.flush(0x40)
	conn.sock.send(buf.data, buf.len) or { panic(err) }
}

pub fn (conn mut server.Connection) write_chunk(x, z int, server &server.Server) {
	world := server.world_manager.get_world('world') or { panic(err) }
	chunk := world.get_chunk(x, z)
	buf := chunk.to_buffer()

	conn.sock.send(buf.data, buf.len) or { panic(err) }
}

pub fn (conn mut server.Connection) write_spawn_pos(x, y, z int) {
	writer := io.create_buf_writer()
	writer.create_empty()
	writer.write_position(x, y, z)

	buf := writer.flush(0x4E)
	conn.sock.send(buf.data, buf.len) or { panic(err) }
}