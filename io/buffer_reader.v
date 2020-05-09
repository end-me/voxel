module io

import net
import encoding.binary

struct BufferReader {
mut:
	buf []byte
	offset int
}

pub fn create_buf_reader() BufferReader {
	return BufferReader{}
}

pub fn (reader mut BufferReader) set_buffer(buf byteptr, len int) {
	mut b := []byte{}
	for i := 0; i < len; i++ {
		b << buf[i]
	}
	reader.set(0, b)
}

pub fn (reader mut BufferReader) set_buffer_a(buf []byte) {
	reader.set(0, buf)
}

pub fn (reader mut BufferReader) set(offset int, buf []byte) {
	reader.offset = 0
	reader.buf = buf
}

fn (reader mut BufferReader) read_byte() byte {
	b := reader.buf[reader.offset]
	reader.offset += 1
	return b
}

fn (reader mut BufferReader) read(len int) []byte {
	mut data := []byte{}
	for i := 0; i < len; i++ {
		data << reader.read_byte()
	}
	return data
}

pub fn (reader mut BufferReader) read_var(max int) ?(i64, int) {
	mut size := 0
	mut result := i64(0)
	for {
		b := reader.read_byte()
		result |= (b & 0b01111111) << (7 * size)
		size += 1
		if size > max {
			return error('Var is too long')
		}
		if (b & 0b10000000) == 0 {
			break
		}
	}
	return result, size
}

pub fn (reader mut BufferReader) read_var_int() ?(int, int) {
	a, b := reader.read_var(10) or { return error(err) }
	return int(a), b
}

pub fn (reader mut BufferReader) read_var_long() ?(i64, int) {
	a, b := reader.read_var(10) or { return error(err) }
	return a, b
}

pub fn (reader mut BufferReader) read_pure_var(max int) i64 {
	i, _ := reader.read_var(max) or { return 0 }
	return i
}

pub fn (reader mut BufferReader) read_pure_var_int() int {
	return int(reader.read_pure_var(5))
}

pub fn (reader mut BufferReader) read_pure_var_long() i64 {
	return reader.read_pure_var(10)
}

pub fn (reader mut BufferReader) read_string() string {
	len := reader.read_pure_var_int()
	return string(reader.read(len))
}

pub fn (reader mut BufferReader) read_short() i16 {
	return i16(binary.big_endian_u16(reader.read(2)))
}

pub fn (reader mut BufferReader) read_ushort() u16 {
	return binary.big_endian_u16(reader.read(2))
}

pub fn (reader mut BufferReader) read_long() i64 {
	return i64(binary.big_endian_u64(reader.read(8)))
}

pub fn (reader mut BufferReader) read_ulong() u64 {
	return binary.big_endian_u64(reader.read(8))
}