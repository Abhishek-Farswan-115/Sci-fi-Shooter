extends KinematicBody


export var speed := 10
export var ray_length := 2000

var velocity := Vector3()

onready var cam := $Camera
onready var head := $BOLT/RootNode/Mover/Head


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	velocity.x = input.x * speed
	velocity.z = input.y * speed
	move_and_slide(velocity)
	
	var space_state := get_world().direct_space_state
	var mouse_position := get_viewport().get_mouse_position()
	var ray_origin: Vector3 = cam.project_ray_origin(mouse_position)
	var ray_end: Vector3 = ray_origin + cam.project_ray_normal(mouse_position) * ray_length
	var intersection := space_state.intersect_ray(ray_origin, ray_end)
	if not intersection.empty():
		head.look_at(Vector3(intersection.position.x, head.global_translation.y, intersection.position.z), Vector3.UP)
