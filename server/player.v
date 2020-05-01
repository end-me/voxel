module server

struct Player {
	name string
	uuid string
	entity_id int
mut:
	conn &Connection
	health f32
	food_level f32
	gamemode byte
}