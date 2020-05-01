module server

struct Player {
	name string
	uuid string
	entity_id int
	conn Connection
mut:
	health f32
	food_level f32
}