extends AnimatedSprite2D

# Состояния, переменные и другая хуйня
var state="idle"
var screen_size=DisplayServer.screen_get_size()
var drag=false
var colors=["green", "brown"]
var chosen_color=0
var max_color=1

# Спавним утку в середине экрана в самом низу
func _ready():
	get_window().position = Vector2i(screen_size[0]/2, screen_size[1]-160) # Отнимаем размер окна, чтобы утка была на экарне полностью
	print(screen_size)

func _process(delta):
	# Управление состояниями
	if state=="walk_right":
		animation=("walk_"+colors[chosen_color])
		scale=Vector2(5, 5)
		var speed=200*delta
		get_window().position += Vector2i(speed, 0)
	elif state=="walk_left":
		animation=("walk_"+colors[chosen_color])
		scale=Vector2(-5, 5)
		var speed=-200*delta
		get_window().position += Vector2i(speed, 0)
	elif state=="idle":
		animation=("idle_"+colors[chosen_color])
		var speed=0
	walking()
	dragging()
	
func walking():
	# Ходьба (Не перемещение!!! Перемещение смотрите в _process)
	if state == "idle":
		if $Timer.is_stopped():
			$Timer.start(3)
			var what_do_next = randi() % 2
			if what_do_next == 0:
				if get_window().position[0]<screen_size[0]-2*160:
					state = "walk_right"
				else:
					state = "walk_left"
			elif what_do_next == 1:
				if get_window().position[0]>2*160:
					state = "walk_left"	
				else:
					state="walk_right"
	elif state == "walk_right":
		if $Timer.is_stopped():
			$Timer.start(5)
			state = "idle"
	elif state == "walk_left":
		if $Timer.is_stopped():
			$Timer.start(5)
			state = "idle"

func dragging():
	# Таскаем утку по экрану
	if drag==true:
		state="idle"
		var mouse_position = get_viewport().get_mouse_position()
		var global_position=get_window().position+Vector2i(mouse_position)-Vector2i(100, 100) # Грубо говоря, задаем центр
		print("Mouse position: ", global_position)
		get_window().position=global_position # Меняем координату

func change_color():
	# Изменение цвета утки (игра со списком)
	chosen_color+=1
	if chosen_color>max_color:
		chosen_color=0

func _on_texture_button_button_down(): # Нажатие на утку
	$quack_sound.play() # Кряк!
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): # ЛКМ
		drag = true
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT): # ПКМ
		change_color()

func _on_texture_button_button_up(): # Отжатие
	drag = false
