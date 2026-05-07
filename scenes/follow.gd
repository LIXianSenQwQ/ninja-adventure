extends Camera2D


# 在 Inspector 面板里手动拖入你的 TileMapLayer 节点。
# 注意：类型是 TileMapLayer，不是 TileMap，也不是 TitleMapLayer。
@export var tilemap: TileMapLayer


func _ready() -> void:
	# ================================
	# 1. 安全检查：确认 tilemap 已经被赋值
	# ================================
	# 如果你忘记在 Inspector 里把 TileMapLayer 拖进来，
	# tilemap 就会是 null，后面调用 get_used_rect() 会报错。
	if tilemap == null:
		push_error("tilemap 没有赋值，请在 Inspector 里拖入 TileMapLayer 节点")
		return

	# ================================
	# 2. 安全检查：确认 TileMapLayer 有 TileSet
	# ================================
	# TileMapLayer 本身只是地图层，
	# 具体每个格子的大小存在它使用的 TileSet 里。
	if tilemap.tile_set == null:
		push_error("TileMapLayer 没有设置 TileSet，无法获取 tile_size")
		return

	# ================================
	# 3. 获取 TileMapLayer 已使用区域
	# ================================
	# get_used_rect() 返回的是 Rect2i。
	#
	# 它不是像素坐标，而是“格子坐标”。
	#
	# 例如：
	# 如果你的地图从第 0 格画到第 99 格，
	# map_rect.size.x 可能是 100。
	#
	# 如果你的地图从第 -10 格画到第 20 格，
	# map_rect.position.x 可能是 -10。
	var map_rect: Rect2i = tilemap.get_used_rect()

	# ================================
	# 4. 获取单个瓦片的像素大小
	# ================================
	#
	# TileMapLayer 的 tile 大小应该从 TileSet 里拿：
	# tilemap.tile_set.tile_size
	#
	# 例如常见值：
	# Vector2i(16, 16)
	# Vector2i(32, 32)
	# Vector2i(64, 64)
	var tile_size: Vector2i = tilemap.tile_set.tile_size

	# ================================
	# 5. 计算地图左上角的像素位置
	# ================================
	# map_rect.position 是格子坐标。
	# tile_size 是每格多少像素。
	#
	# 所以：
	# 格子坐标 * 每格像素 = 像素坐标
	#
	# 这里不用直接写 map_rect.position * tile_size，
	# 是为了更清楚，也避免类型问题。
	var map_start_in_pixels: Vector2i = Vector2i(
		map_rect.position.x * tile_size.x,
		map_rect.position.y * tile_size.y
	)

	# ================================
	# 6. 计算整张地图的像素尺寸
	# ================================
	# map_rect.size 是地图占用了多少个格子。
	#
	# 例如：
	# 地图宽 100 格，每格 16 像素，
	# 那地图宽度就是 100 * 16 = 1600 像素。
	var map_size_in_pixels: Vector2i = Vector2i(
		map_rect.size.x * tile_size.x,
		map_rect.size.y * tile_size.y
	)

	# ================================
	# 7. 计算地图右下角的像素位置
	# ================================
	# 地图结束位置 = 地图起始位置 + 地图大小
	var map_end_in_pixels: Vector2i = map_start_in_pixels + map_size_in_pixels

	# ================================
	# 8. 设置 Camera2D 的移动限制
	# ================================
	# limit_left   ：摄像机最左能看到哪里
	# limit_top    ：摄像机最上能看到哪里
	# limit_right  ：摄像机最右能看到哪里
	# limit_bottom ：摄像机最下能看到哪里
	#
	# 如果你的地图一定从坐标 (0, 0) 开始，
	# 你也可以只设置 right 和 bottom。
	#
	# 但更推荐四个都设置，
	# 因为有些地图可能从负坐标开始画。
	limit_left = map_start_in_pixels.x
	limit_top = map_start_in_pixels.y
	limit_right = map_end_in_pixels.x
	limit_bottom = map_end_in_pixels.y

	# ================================
	# 9. 调试输出
	# ================================
	# 运行后可以在 Output 面板里看计算结果，
	# 方便确认地图范围有没有算对。
	print("地图格子范围: ", map_rect)
	print("单个瓦片大小: ", tile_size)
	print("地图像素起点: ", map_start_in_pixels)
	print("地图像素大小: ", map_size_in_pixels)
	print("地图像素终点: ", map_end_in_pixels)
