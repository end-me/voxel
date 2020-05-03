module io

//import nbt

struct BufferWriter {
mut:
	buf []byte
}

pub fn create_buf_writer() BufferWriter {
	return BufferWriter{}
}

pub fn (writer mut BufferWriter) create_empty() {
	writer.buf = []byte{}
}

pub fn (writer mut BufferWriter) set_buffer(buf []byte) {
	writer.buf = buf
}

pub fn (writer mut BufferWriter) write_var_int(val int) {
	mut data := val
	for {
		mut tmp := (data & 0b01111111)
		data >>= 7

		if data != 0 {
			tmp |= 0b10000000
		}
		writer.buf << byte(tmp)
		println(data)
		if data == 0 {
			break
		}
	}
}

pub fn (writer mut BufferWriter) write_var_long(val i64) {
	mut data := val
	for {
		mut tmp := (data & 0b01111111)
		data >>= 7

		if data != 0 {
			tmp |= 0b10000000
		}
		writer.buf << byte(tmp)
		if data == 0 {
			break
		}
	}
}

pub fn (writer mut BufferWriter) write_string(str string) {
	buf := str.bytes()
	writer.write_var_int(buf.len)
	writer.buf << buf
}

pub fn (writer mut BufferWriter) write_string_enum(str string) {
	buf := str.bytes()
	writer.write_var_int(buf.len)
}

pub fn (writer mut BufferWriter) write_long(l i64) {
	mut v := l
	writer.buf << byte(v>>56)
	writer.buf << byte(v>>48)
	writer.buf << byte(v>>40)
	writer.buf << byte(v>>32)
	writer.buf << byte(v>>24)
	writer.buf << byte(v>>16)
	writer.buf << byte(v>>8)
	writer.buf << byte(v)
}

pub fn (writer mut BufferWriter) write_ulong(l u64) {
	mut v := l
	writer.buf << byte(v>>56)
	writer.buf << byte(v>>48)
	writer.buf << byte(v>>40)
	writer.buf << byte(v>>32)
	writer.buf << byte(v>>24)
	writer.buf << byte(v>>16)
	writer.buf << byte(v>>8)
	writer.buf << byte(v)
}

pub fn (writer mut BufferWriter) write_int(i int) {
	mut v := i
	writer.buf << byte(v>>24)
	writer.buf << byte(v>>16)
	writer.buf << byte(v>>8)
	writer.buf << byte(v)
}

pub fn (writer mut BufferWriter) write_short(l i16) {
	mut v := l
	writer.buf << byte(v>>8)
	writer.buf << byte(v)
}

pub fn (writer mut BufferWriter) write_byte(b byte) {
	writer.buf << b
}

pub fn (writer mut BufferWriter) write_bool(b bool) {
	if b {
		writer.buf << byte(0x01)
	} else {
		writer.buf << byte(0x00)
	}
}

pub fn (writer mut BufferWriter) write_array(b []byte) {
	writer.write_var_int(b.len)
	if b.len > 0 {
		writer.buf << b
	}
}

pub fn (writer mut BufferWriter) write_position(x, y, z int) {
	b := byte(((x & 0x3FFFFFF) << 38) | ((z & 0x3FFFFFF) << 12) | (y & 0xFFF))
	writer.buf << b
}

pub fn (writer mut BufferWriter) write_empty_heightmap() {
	writer.write_byte(byte(10))
	writer.write_byte(0)
	writer.write_byte(0)
	writer.write_byte(byte(12))
	writer.write_nbt_text('MOTION_BLOCKING')
	writer.write_int(0)
}
/*
pub fn (writer mut BufferWriter) write_nbt(data nbt.NbtCompound) {
	writer.write_byte(byte(data.typ()))
	writer.write_byte(0)
	writer.write_byte(0)
	writer.write_nbt_data(data)
}

fn (writer mut BufferWriter) write_nbt_data(data nbt.Nbt) {
	match (data as nbt.INbt).typ() {
		0 {

		}
		1 {
			writer.write_byte(byte((data as nbt.NbtByte).val))
		}
		10 {
			for name in (data as nbt.NbtCompound).val {
				tag := (data as nbt.NbtCompound).val[string(name)]

				writer.write_byte(byte((tag as nbt.INbt).typ()))

				typ := (tag as nbt.INbt).typ()

				if byte(typ) == 0 {
					continue
				}

				writer.write_nbt_text(name)
				writer.write_nbt(tag)
			}
		}
		12 {
			val := (data as nbt.NbtLongArray).val
			writer.write_int(val.len)

			for v in val {
				writer.write_long(v)
			}
		}
		else {
			panic('unimplemented')
		}
	}
}*/

fn (writer mut BufferWriter) write_nbt_text(data string) {
	println(data.len)
	writer.write_short(data.len)
	for a in data.bytes() {
		char := byte(a)
		d := int(char)
		println('$char -> $d')
	}
	writer.buf << data.bytes()
}

pub fn (writer mut BufferWriter) write(b []byte) {
	writer.buf << b
}

pub fn (writer mut BufferWriter) flush(id int) []byte {
	mut buf := writer.buf.clone()
	writer.create_empty()

	mut pkt_id := [byte(0x00)]
	if id > 0 {
		writer.write_var_int(id)
		pkt_id = writer.buf.clone()
		writer.create_empty()
	}

	writer.write_var_int(buf.len + pkt_id.len)
	mut buf_len := writer.buf.clone()
	writer.create_empty()

	buf_len << pkt_id
	buf_len << buf

	return buf_len
}

pub fn (writer mut BufferWriter) to_buffer() []byte {
	return writer.buf
}