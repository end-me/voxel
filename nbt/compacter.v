module nbt

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

	comp.values[s_index] = comp.values[s_index]&i64((comp.max<<u_index)) | i64((val&comp.max)<<u_index)

	if s_index != e_index {
		s_index = 64 - u_index
		p_index = comp.bpb - 1

		prev_val |= (comp.values[e_index] << z_index) & i64(comp.max)

		comp.values[e_index] = i64(((u64(comp.values[e_endex]) >> p_index) << p_index) | u64((value&comp.max)>>z_index))
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

	return int(u64(comp.values[s_index] >> u_index) & u64(comp.max))
}

fn calc_slice(var0, var1 int) int {
	if var1 == 0 {
		return 0
	} else if var0 == 0 {
		return var1
	} else {
		if var0 < 0 {
			var1 *= -1
		}
		var2 := var0 % var1
		if var2 == 0 {
			return var0
		} else {
			return var0 + var1 - var2
		}
	}
}