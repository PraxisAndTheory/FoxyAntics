extends EnemyBase

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var jump_timer = $JumpTimer

const JUMP_VELOCITY: Vector2 = Vector2(100, -150)
const JUMP_WAIT_RANGE: Vector2 = Vector2(2.5, 5.0)

var _jump: bool = false
var _seen_player: bool = false



# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	jump_timer.wait_time = randf_range(JUMP_WAIT_RANGE.x, JUMP_WAIT_RANGE.y)
	jump_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
	
	if not is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.x = 0
		animated_sprite_2d.play("idle")
	
	apply_jump()
	move_and_slide()
	flip_me()

func apply_jump():
	if not is_on_floor():
		return
	
	if not _seen_player or not _jump:
		return
	
	velocity = JUMP_VELOCITY
	
	if not animated_sprite_2d.flip_h:
		velocity.x *= -1
	
	_jump = false
	
	animated_sprite_2d.play("jump")
	jump_timer.start()

func flip_me() -> void:
	if(
		_player_ref.global_position.x > global_position.x
		and not animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = true
	elif(_player_ref.global_position.x < global_position.x
		and animated_sprite_2d.flip_h):
		animated_sprite_2d.flip_h = false

func _on_jump_timer_timeout():
	_jump = true

func _on_visible_on_screen_notifier_2d_screen_entered():
	_seen_player = true
