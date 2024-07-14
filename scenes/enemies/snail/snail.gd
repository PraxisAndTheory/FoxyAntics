extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var floor_detection = $FloorDetection

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = speed * _facing
	move_and_slide()
	
	if is_on_floor():
		if is_on_wall() or not floor_detection.is_colliding():
			flip_me()

func flip_me() -> void:
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h
	floor_detection.position.x *= -1
	
	if _facing == FACING.LEFT:
		_facing = FACING.RIGHT
	else:
		_facing = FACING.LEFT
