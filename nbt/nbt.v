module nbt

type Typ = byte
type Nbt = NbtEnd | NbtByte | NbtCompound | NbtLongArray

pub struct NbtEnd {}

pub fn (n NbtEnd) typ() Typ {
	return Typ(0)
}

pub fn (n NbtEnd) name() string {
	return 'TAG_End'
}

pub struct NbtByte {
	val i8
}

pub fn (n NbtByte) typ() Typ {
	return Typ(1)
}

pub fn (n NbtByte) name() string {
	return 'TAG_Byte'
}

pub struct NbtShort {
	val i16
}

pub fn (n NbtShort) typ() Typ {
	return Typ(2)
}

pub fn (n NbtShort) name() string {
	return 'TAG_Short'
}

pub struct NbtInt {
	val int
}

pub fn (n NbtInt) typ() Typ {
	return Typ(3)
}

pub fn (n NbtInt) name() string {
	return 'TAG_Int'
}

pub struct NbtLong {
	val i64
}

pub fn (n NbtLong) typ() Typ {
	return Typ(4)
}

pub fn (n NbtLong) name() string {
	return 'TAG_Long'
}

pub struct NbtFloat {
	val f32
}

pub fn (n NbtFloat) typ() Typ {
	return Typ(5)
}

pub fn (n NbtFloat) name() string {
	return 'TAG_Float'
}

pub struct NbtDouble {
	val f64
}

pub fn (n NbtDouble) typ() Typ {
	return Typ(6)
}

pub fn (n NbtDouble) name() string {
	return 'TAG_Double'
}

pub struct NbtByteArray {
	val []i8
}

pub fn (n NbtByteArray) typ() Typ {
	return Typ(7)
}

pub fn (n NbtByteArray) name() string {
	return 'TAG_Byte_Array'
}

pub struct NbtString {
	val string
}

pub fn (n NbtString) typ() Typ {
	return Typ(8)
}

pub fn (n NbtString) name() string {
	return 'TAG_String'
}

pub struct NbtAnyArray {
	val []Nbt
	ntype Typ
}

pub fn (n NbtAnyArray) typ() Typ {
	return Typ(9)
}

pub fn (n NbtAnyArray) name() string {
	return 'TAG_List'
}

pub struct NbtCompound {
	named string
mut:
	val map[string]Nbt
}

pub fn (n NbtCompound) typ() Typ {
	return Typ(10)
}

pub fn (n NbtCompound) name() string {
	return "TAG_Compound"
}

pub fn (n mut NbtCompound) set(name string, data Nbt) {
	n.val[name] = data
}

pub fn (n NbtCompound) get(name string) Nbt {
	nbt := n.val[name]
	return nbt
}

pub struct NbtIntArray {
	val []i32
}

pub fn (n NbtIntArray) typ() Typ {
	return Typ(11)
}

pub fn (n NbtIntArray) name() string {
	return 'TAG_Int_Array'
}

pub struct NbtLongArray {
	val []i64
}

pub fn (n NbtLongArray) typ() Typ {
	return Typ(12)
}

pub fn (n NbtLongArray) name() string {
	return 'TAG_Long_Array'
}
