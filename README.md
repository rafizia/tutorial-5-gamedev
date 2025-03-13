Nama: Muhammad Rafi Zia Ulhaq<br>
NPM: 2206814551<br>

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
