module nbt

type Typ = byte

interface Nbt {
	typ() Typ
	name() string
}

struct NbtEnd {}

pub fn (n NbtByte) typ() Typ {
	return 0
}

pub fn (n NbtByte) name() string {
	return 'TAG_End'
}

struct NbtByte {
	val i8
}

pub fn (n NbtByte) typ() Typ {
	return 1
}

pub fn (n NbtByte) name() string {
	return 'TAG_Byte'
}

struct NbtShort {
	val i16
}

pub fn (n NbtShort) typ() Typ {
	return 2
}

pub fn (n NbtShort) name() string {
	return 'TAG_Short'
}

struct NbtInt {
	val int
}

pub fn (n NbtInt) typ() Typ {
	return 3
}

pub fn (n NbtInt) name() string {
	return 'TAG_Int'
}

struct NbtLong {
	val i64
}

pub fn (n NbtLong) typ() Typ {
	return 4
}

pub fn (n NbtLong) name() string {
	return 'TAG_Long'
}

struct NbtFloat {
	val f32
}

pub fn (n NbtFloat) typ() Typ {
	return 5
}

pub fn (n NbtFloat) name() string {
	return 'TAG_Float'
}

struct NbtDouble {
	val f64
}

pub fn (n NbtDouble) typ() Typ {
	return 6
}

pub fn (n NbtDouble) name() string {
	return 'TAG_Double'
}

struct NbtByteArray {
	val []i8
}

pub fn (n NbtByteArray) typ() Typ {
	return 7
}

pub fn (n NbtByteArray) name() string {
	return 'TAG_Byte_Array'
}

struct NbtString {
	val string
}

pub fn (n NbtString) typ() Typ {
	return 8
}

pub fn (n NbtString) name() string {
	return 'TAG_String'
}

struct NbtAnyArray {
	val []Nbt
	ntype Typ
}

pub fn (n NbtAnyArray) typ() Typ {
	return 9
}

pub fn (n NbtAnyArray) name() string {
	return 'TAG_List'
}

struct NbtCompound {
	named string
	val map[string]Nbt
}

pub fn (n NbtCompound) typ() Typ {
	return 10
}

pub fn (n NbtCompound) name() string {
	return "TAG_Compound"
}

pub fn (n mut NbtCompound) set(name string, data Nbt) {
	n.val[name] = data
}

pub fn (n NbtCompound) Get(name string) Nbt {
	nbt = n.val[name]
	return nbt
}

struct NbtIntArray {
	val []i32
}

pub fn (n NbtByteArray) typ() Typ {
	return 11
}

pub fn (n NbtByteArray) name() string {
	return 'TAG_Int_Array'
}

struct NbtLongArray {
	val []i64
}

pub fn (n NbtByteArray) typ() Typ {
	return 12
}

pub fn (n NbtByteArray) name() string {
	return 'TAG_Long_Array'
}

