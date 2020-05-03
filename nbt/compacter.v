module nbt
/*
struct Compacter {
	bpb int
	max int
mut:
	values []i64
}

pub fn create_new_compacter(bits, size int) &Compacter {
	slice := calc_slice(bits*size, 64) / 64

	return &Compacter{
		bpb: bits
		max: size
		values: []i64{len: slice, cap: slice}
	}
}

pub fn (comp mut Compacter) set(index, val int) {
	b_index := index * comp.bpb

	s_index := b_index >> 0x06
	e_index := (((index + 1) * comp.bpb) - 1) >> 0x06

	u_index := b_index ^ (s_index << 0x06)

	prev_val := i64(u64(comp.values[s_index])>>u_index) & i64(comp.max)

	comp.values[s_index] = comp.values[s_index]&i64((comp.max<<u_index)^-1) | i64((val&comp.max)<<u_index)

	if s_index != e_index {
		z_index := 64 - u_index
		p_index := comp.bpb - 1

		mut prev_val |= (comp.values[e_index] << z_index) & i64(comp.max)

		comp.values[e_index] = i64(((u64(comp.values[e_index]) >> p_index) << p_index) | u64((val&comp.max)>>z_index))
	}
}

pub fn (comp Compacter) get(index int) int {
	b_index := index * comp.bpb

	s_index := b_index >> 0x06
	e_index := (((index + 1) * comp.bpb) -1) >> 0x06

	u_index := b_index ^ (s_index << 0x06)

	if z_index == e_index {
		return int((u64(comp.values[s_index]) >> u_index) & u64(comp.max))
	}

	z_index := 64 - u_index

	return int(u64(comp.values[z_index] >> u_index) & u64(comp.max))
}

fn calc_slice(var0, var1 int) int {
	mut v0 := var0
	mut v1 := var1
	if v1 == 0 {
		return 0
	} else if v0 == 0 {
		return v1
	} else {
		if v0 < 0 {
			v1 *= -1
		}
		var2 := v0 % v1
		if var2 == 0 {
			return v0
		} else {
			return v0 + v1 - var2
		}
	}
}*/