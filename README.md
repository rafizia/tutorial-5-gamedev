Nama: Muhammad Rafi Zia Ulhaq<br>
NPM: 2206814551<br>

# Tutorial 5

## Membuat Objek Baru Slime

Merupakan sebuah objek bertipe enemy yang akan bergerak ke kanan dan ke kiri di suatu area. Jika player bertabrakan dengan objek ini maka player akan mati dan restart level tersebut.

### Penjelasan

Pada objek ini saya menggunakan AnimatedSprite2D untuk membuat animasi gerakan slime. Kemudian saya juga menggunakan sebuah Hitbox di mana jika player bertabrakan dengan Hitbox tersebut maka player akan mati dan restart level tersebut. Selain itu saya juga menambahkan RayCast2D untuk mengatur pergerakan slime.
```
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft

func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		$AnimatedSprite2D.flip_h = false
	if ray_cast_left.is_colliding():
		direction = 1
		$AnimatedSprite2D.flip_h = true
	position.x += direction * SPEED * delta
```
`_process()`: mengontrol pergerakan slime secara otomatis dengan mendeteksi dinding menggunakan RayCast2D. Jika slime menabrak dinding di kanan atau kiri, maka ia akan berbalik arah.
```
# Kode Hitbox

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "Player"):
		body.dead()
		$Timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
```
```
# Fungsi dead() pada Player

func dead():
	is_dead = true
	velocity.x = 0
	$AudioStreamPlayer2D.play()
	$AnimatedSprite2D.play("dead")
```
`_on_body_entered()`: ketika player bertabrakan dengan slime, maka player akan mati dan restart level tersebut.

## Menambahkan SFX pada Objek Shooter

Saya menambahkan SFX `arrow-swish_03-306040.mp3` pada objek Shooter, sehingga akan muncul sound effect ketika Shooter menembakkan sebuah Arrow.

### Penjelasan
```
func _ready():
	$Timer.wait_time = shoot_interval
	$Timer.start()

func _on_timer_timeout():
	var arrow = arrow_scene.instantiate() as RigidBody2D
	arrow.global_position = global_position
	arrow.linear_velocity = shoot_direction * shoot_speed
	$AudioStreamPlayer2D.play()     # memainkan SFX
	get_parent().add_child(arrow)
```
`_on_timer_timeout()`: Ketika timer habis maka Shooter akan menembakkan sebuah arrow dan memainkan SFX `arrow-swish_03-306040.mp3`.

## Menambahkan SFX pada Objek FallingSpike

Saya menambahkan SFX `falling-whistle-swish-1-84769.mp3` pada objek FallingSpike, sehingga akan muncul sound effect ketika FallingSpike jatuh.

### Penjelasan
```
func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player": 
		$AnimationPlayer.play("fall")
		$AudioStreamPlayer2D.play()     # memainkan SFX
```
`_on_player_detect_body_entered()`: Ketika player lewat di bawah spike tersebut, maka spike tersebut akan jatuh dan memainkan SFX `falling-whistle-swish-1-84769.mp3`.

## Menambahkan SFX ketika Player Mati
Saya menambahkan SFX `male-death-sound-128357.mp3` pada objek Player, sehingga akan muncul sound effect ketika Player tersebut mati.

### Penjelasan
```
# Fungsi dead() pada Player

func dead():
	is_dead = true
	velocity.x = 0
	$AudioStreamPlayer2D.play()     # memainkan SFX
	$AnimatedSprite2D.play("dead")
```
`dead()`: Fungsi ini akan memainkan sebuah sfx `male-death-sound-128357.mp3` dan memainkan sebuah animasi dead pada Player.

## Menambahkan SFX ketika Player Mencapai Finish Area
Saya menambahkan SFX `success-fanfare-trumpets-6185.mp3` pada objek FinishArea, sehingga akan muncul sound effect ketika Player tersebut menang.

### Penjelasan
```
func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":
		body.show_win()
		$AudioStreamPlayer.play()       # memainkan SFX
		await get_tree().create_timer(5).timeout
		get_tree().call_deferred("reload_current_scene")
```
`_on_body_entered()`: ketika player menyentuh FinishArea maka mainkan sfx `success-fanfare-trumpets-6185.mp3` dan game akan menang.

## Menambahkan BGM
Saya menambahkan BGM `fun-retro-game-175468.mp3` untuk level 1 dan level 2.

### Penjelasan
Saya menambahkan node AudioStreamPlayer pada scene Level 1 dan Level 2. Tidak lupa untuk mengaktifkan autoplay agar BGM otomatis dimainkan ketika game dimulai serta mengaktifkan loop agar BGM tersebut tetap dimainkan ketika durasinya habis.

#### Referensi:
SFX dan BGM diunduh dari https://pixabay.com/


# Tutorial 4

## Tilemap

![alt text](https://github.com/rafizia/tutorial-4-gamedev/blob/main/image/tilemap.png?raw=true)
Saya menggunakan tileset dari [PLATFORMER/METROIDVANIA ASSET PACK](https://o-lobster.itch.io/platformmetroidvania-pixel-art-asset-pack) di itch.io dengan ukuran 64x64.

## Spawner Arrow (Shooter)
![alt text](https://github.com/rafizia/tutorial-4-gamedev/blob/main/image/shooter.png?raw=true)
Merupakan sebuah Spawner yang menembakkan sebuah Arrow secara horizontal. Jika Player terkena Arrow tersebut maka Player akan mati dan mengulang level tersebut.
#### Penjelasan
Membuat sebuah scene baru berupa sebuah Sprite untuk menampilkan Spawner tersebut dan sebuah script untuk menembakkan Arrow.
```
@export var arrow_scene: PackedScene
@export var shoot_direction: Vector2 = Vector2.LEFT
@export var shoot_speed: float = 1000
@export var shoot_interval: float = 3.0

func _ready():
	$Timer.wait_time = shoot_interval           # mengatur waktu sesuai shoot_interval
	$Timer.start()                              # mulai timer

func _on_timer_timeout():
	var arrow = arrow_scene.instantiate() as RigidBody2D       # spawn Arrow
	arrow.global_position = global_position                    # meletakkan Arrow
	arrow.linear_velocity = shoot_direction * shoot_speed      # memberi kecepatan Arrow
	get_parent().add_child(arrow)                              # menambahkan Arrow ke dalam scene
```
`_ready()`: berisi sebuah timer untuk menembak Arrow secara berkala.<br>
`_on_timer_timeout()`: membuat objek Arrow dan menambahkan Arrow tersebut ke dalam scene.<br>
Selanjutnya membuat sebuah scene baru bertipe RigidBody untuk menampilkan Arrow dan script untuk membuat Player mati jika terkena Arrow tersebut.
![alt text](https://github.com/rafizia/tutorial-4-gamedev/blob/main/image/arrow.png?raw=true)
```
@export var speed: float = 300
@export var direction: Vector2 = Vector2.LEFT

func _physics_process(delta):
	linear_velocity = direction * speed     # mengatur kecepatan

func _on_body_entered(body: Node):
	if body.get_name() == "Player":
		get_tree().call_deferred("reload_current_scene")    # reload level
```
`_physics_process(delta)`: mengatur kecepatan Arrow tersebut.<br>
`_on_body_entered(body: Node)`: saat Arrow mengenai Player, maka level akan di reload.

## Falling Spike
![alt text](https://github.com/rafizia/tutorial-4-gamedev/blob/main/image/spike.png?raw=true)
Merupakan sebuah objek berbentuk spike yang akan jatuh ketika Player lewat di bawahnya. Player akan mati jika terkena spike tersebut.
#### Penjelasan
Membuat scene baru yang berisi sebuah Sprite untuk menampilkan gambar Spike, Area2D Hitbox sebagai trigger jika Player terkena Spike, dan Area2D PlayerDetect untuk mendeteksi Player saat lewat di bawah Spike tersebut.
```
@export var speed = 160.0
var current_speed = 0.0


func _physics_process(delta: float) -> void:
	position.y += current_speed * delta     # menjatuhkan Spike

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player":        
		get_tree().call_deferred("reload_current_scene")
	
func _on_player_detect_body_entered(body: Node2D) -> void:
	if body.get_name() == "Player": 
		$AnimationPlayer.play("fall")
		
func fall():
	current_speed = speed       # mengganti kecepatan Spike agar terjatuh
	await get_tree().create_timer(5).timeout       # tunggu 5 detik
	queue_free()                                   # hapus objek
```
`_physics_process(delta: float)`: menjatuhkan Spike sesuai kecepatan current_speed<br>
`_on_hitbox_body_entered(body: Node2D)`: jika terkena Player, maka reload level<br>
`_on_player_detect_body_entered(body: Node2D)`: mendeteksi Player saat lewat di bawahnya<br>
`fall()`: mengganti kecepatan Spike agar jatuh

## Falling Stone
![alt text](https://github.com/rafizia/tutorial-4-gamedev/blob/main/image/stone.png?raw=true)
Merupakan sebuah batu berbentuk bola yang akan jatuh dan menggelinding ketika Player lewat di bawahnya. Player akan mati jika terkena batu tersebut.
#### Penjelasan
Membuat scene baru yang berisi sebuah Sprite untuk menampilkan gambar batu, Hitbox sebagai trigger jika Player terkena batu, dan Area2D untuk mendeteksi Player saat lewat di bawah batu tersebut.
```
func _ready():
	gravity_scale = 0.0
	
func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		gravity_scale = 1.0         # mengganti nilai gravitasi
		await get_tree().create_timer(10).timeout
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		get_tree().call_deferred("reload_current_scene")
```
`_ready()`: mengatur gravitasi menjadi 0 agar batu tidak jatuh<br>
`_on_area_2d_body_entered(body)`: mendeteksi Player saat lewat di bawah batu tersebut dan mengganti nilai gravitasi menjadi 1 agar batu terjatuh<br>
`_on_body_entered(body: Node)`: jika terkena Player, maka reload level


##### Referensi:
https://www.youtube.com/watch?v=p83cg4OYGAE&t=327s<br>


# Tutorial 3

## Double Jump
```
var double_jump = false
...
if Input.is_action_just_pressed("ui_up"):
	if is_on_floor():
		velocity.y = jump_speed
		double_jump = true
	elif double_jump:
		velocity.y = jump_speed
		double_jump = false
```
#### Penjelasan
```
if is_on_floor():
	velocity.y = jump_speed
	double_jump = true
```
Kode untuk melakukan lompatan biasa, namun ketika karakter sudah melompat sekali, maka flag `double jump` akan menjadi `true`.
```
elif double_jump:
        velocity.y = jump_speed
        double_jump = false
```
Karena flag `double_jump = true`, jika pemain menekan panah atas sekali lagi, maka karakter dapat melakukan double jump, sehingga karakter bisa melompat sekali lagi di udara. Terakhir ubah kembali flag `double_jump` menjadi `false` agar karakter tidak bisa melompat terus menerus.

## Crouching
```
@export var walk_speed = 200
@export var crouch_speed = 100
...
# Contoh move ke kiri
if Input.is_action_pressed("ui_left"):
	$AnimatedSprite2D.flip_h = true
	if Input.is_action_pressed("ui_down"):
		velocity.x = -crouch_speed
		$AnimatedSprite2D.play("crouch")
```
#### Penjelasan
Jika pemain menekan tombol move ke kiri atau ke kanan bersamaan dengan tombol panah bawah, maka karakter akan bergerak dengan kecepatan lebih lambat (`crouch_speed`).

## Dashing
```
@export var dash_speed = 900
var dash = false
var can_dash = true
var last_left_move_time = 0
var last_right_move_time = 0
const dash_interval = 0.1

# Contoh move ke kiri
if Input.is_action_pressed("ui_left"):
	...
	else:
		$AnimatedSprite2D.play("run")	
		if Input.is_action_just_pressed("ui_left") and can_dash:
			if Time.get_ticks_msec() / 1000 - last_left_move_time < dash_interval:
				dash = true
				can_dash = false
				$DashTimer.start()
				$CanDashTimer.start()
			else:
				dash = false
			last_left_move_time = Time.get_ticks_msec() / 1000
		if dash:
			velocity.x = -dash_speed
		else:
			velocity.x = -walk_speed
...
func _on_can_dash_timer_timeout() -> void:
	can_dash = true
	
func _on_dash_timer_timeout() -> void:
	dash = false
```
### Penjelasan
Jika pemain menekan tombol move dua kali dengan selisih waktu kurang dari 0.1 detik, maka karakter akan memasuki mode dash dengan mengubah flag `dash` menjadi `true` dan mengubah flag `can_dash` menjadi `false` untuk mencegah dash secara terus menerus. Saat `dash = true` maka karakter bergerak dengan kecepatan yang lebih cepat (`dash_speed`). Kemudian `DashTimer` dan `CanDashTimer` akan dijalankan untuk membatasi durasi dash dan cooldown dash. Saat `DashTimer` habis, dash berhenti sehingga karakter kembali ke kecepatan normal. Saat `CanDashTimer` habis, maka karakter bisa melakukan dash lagi.

##### Referensi:
https://www.youtube.com/watch?v=LOhfqjmasi0<br>
https://www.youtube.com/watch?v=A-Y1zxJ6oH4<br>
https://www.youtube.com/watch?v=f8z4x6R7OSM&t=17s





