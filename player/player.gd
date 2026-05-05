extends CharacterBody2D


@export  var speed: = 130.0

@onready var animation=$AnimationPlayer

func _vector_to_current_suffix(direction: Vector2) -> StringName:
	# 根据输入方向判断应该播放哪个方向的动画
	#
	# 如果横向输入绝对值更大，就认为角色在左右移动
	# 如果纵向输入绝对值更大，就认为角色在上下移动
	#
	# 例如：
	# Vector2(1, 0)  -> right
	# Vector2(-1, 0) -> left
	# Vector2(0, 1)  -> down
	# Vector2(0, -1) -> up

	if abs(direction.x) >= abs(direction.y):
		return &"right" if direction.x > 0.0 else &"left"

	return &"down" if direction.y > 0.0 else &"up"
	
	
func handleInput():
	var moveDirection=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity=moveDirection*speed
	if velocity == Vector2.ZERO :
		animation.stop()
	else:
		var suffix=_vector_to_current_suffix(moveDirection)
		animation.play("walk_%s" % suffix)
	
func _physics_process(_delta: float) -> void:
	handleInput()
	move_and_slide()
