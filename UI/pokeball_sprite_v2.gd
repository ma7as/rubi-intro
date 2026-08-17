@tool
extends AnimatedSprite2D

class_name PokeballSprite2

# Enum para los tipos de Pokéball
enum TipoPokeball {
	POKEBALL,
	GREATBALL,
	ULTRABALL,
	REPEATBALL,
	DIVEBALL,
	PREMIERBALL,
	LUXURYBALL,
	NETBALL,
	MASTERBALL,
	NESTBALL,
	SAFARIBALL,
	TIMERBALL
}

# Mapeo de strings a enum para facilidad de uso
const NOMBRES_POKEBALL = {
	"POKEBALL": TipoPokeball.POKEBALL,
	"GREATBALL": TipoPokeball.GREATBALL,
	"ULTRABALL": TipoPokeball.ULTRABALL,
	"REPEATBALL": TipoPokeball.REPEATBALL,
	"DIVEBALL": TipoPokeball.DIVEBALL,
	"PREMIERBALL": TipoPokeball.PREMIERBALL,
	"LUXURYBALL": TipoPokeball.LUXURYBALL,
	"NETBALL": TipoPokeball.NETBALL,
	"MASTERBALL": TipoPokeball.MASTERBALL,
	"NESTBALL": TipoPokeball.NESTBALL,
	"SAFARIBALL": TipoPokeball.SAFARIBALL,
	"TIMERBALL": TipoPokeball.TIMERBALL
}

# Estados de la animación de ball
enum EstadoAnimacion {
	CERRADA,      # Frame 0 - Para pantalla info
	MEDIO_ABIERTA, # Frame 1 - Animación intermedia
	ABIERTA       # Frame 2 - Completamente abierta
}

# Variables de control
@export var tipo_actual: TipoPokeball = TipoPokeball.POKEBALL:
	set(value):
		tipo_actual = value
		if Engine.is_editor_hint() and is_inside_tree():
			_actualizar_sprite_editor()

@export var reproduciendo_captura: bool = false

func _ready() -> void:
	# Cargar texturas
	cargar_texturas()

	# Verificar que el SpriteFrames está configurado
	if not sprite_frames:
		print("❌ [POKEBALL_SPRITE] No hay SpriteFrames configurado")
		return

	# Configurar la animación por defecto
	mostrar_pokeball(TipoPokeball.keys()[tipo_actual], EstadoAnimacion.CERRADA)

## Actualiza el sprite cuando se cambia tipo_actual desde el editor.
func _actualizar_sprite_editor() -> void:
	if not sprite_frames:
		cargar_texturas()

	if sprite_frames:
		var nombre_animacion = TipoPokeball.keys()[tipo_actual].to_lower()
		if sprite_frames.has_animation(nombre_animacion):
			play(nombre_animacion)
			pause()
			frame = EstadoAnimacion.CERRADA
## Función para cargar texturas automáticamente desde un tileset con todas las Pokéballs.
func cargar_texturas() -> void:
	print("🔧 [POKEBALL_SPRITE] Cargando texturas...")

	var textura_pokeballs: Texture2D = null
	var ruta: String = "res://graficos/batalla/balls-catch.png"
	if ResourceLoader.exists(ruta):
		textura_pokeballs = load(ruta)
		print("✅ [POKEBALL_SPRITE] Textura encontrada en: %s" % ruta)

	# Si encontramos una textura, generar el SpriteFrames
	if textura_pokeballs:
		var nuevo_spriteframes = crear_spriteframes(textura_pokeballs)
		if nuevo_spriteframes:
			sprite_frames = nuevo_spriteframes
			print("🎉 [POKEBALL_SPRITE] Configuración completada!")
		else:
			print("❌ [POKEBALL_SPRITE] Falló la generación de SpriteFrames")
	else:
		print("⚠️ [POKEBALL_SPRITE] No se encontró textura de Pokéballs")

## Crea SpriteFrames para formato estándar: 48x192 (3 frames x 12 balls).
func crear_spriteframes(textura: Texture2D) -> SpriteFrames:
	var frames_pokeballs = SpriteFrames.new()
	var nombres_balls = ["pokeball", "greatball", "ultraball", "repeatball", "diveball",
						 "premierball", "luxuryball", "netball", "masterball",
						 "nestball", "safariball", "timerball"]

	for i in range(nombres_balls.size()):
		var nombre_animacion = nombres_balls[i]
		frames_pokeballs.add_animation(nombre_animacion)
		frames_pokeballs.set_animation_speed(nombre_animacion, 1.0)
		frames_pokeballs.set_animation_loop(nombre_animacion, false)

		# Añadir los 3 frames de cada ball
		for frame_x in range(3):
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = textura
			atlas_texture.region = Rect2(frame_x * 16, i * 16, 16, 16)
			frames_pokeballs.add_frame(nombre_animacion, atlas_texture)

	print("✅ [POKEBALL_SPRITE] SpriteFrames formato estándar creado con %d animaciones" % nombres_balls.size())
	return frames_pokeballs


# --- API PÚBLICA ---

## Muestra una Pokéball específica en un estado determinado.
## Perfecto para la pantalla de información.
func mostrar_pokeball(nombre_ball: String, estado: EstadoAnimacion = EstadoAnimacion.CERRADA) -> void:
	if not NOMBRES_POKEBALL.has(nombre_ball):
		print("❌ [POKEBALL_SPRITE] Tipo de Pokéball desconocido: %s" % nombre_ball)
		return

	tipo_actual = NOMBRES_POKEBALL[nombre_ball]

	# Reproducir la animación correspondiente
	var nombre_animacion = nombre_ball.to_lower()
	if sprite_frames.has_animation(nombre_animacion):
		play(nombre_animacion)

		# Pausar en el frame específico
		pause()
		frame = estado

		print("🥎 [POKEBALL_SPRITE] Mostrando %s (frame %d)" % [nombre_ball, estado])
	else:
		print("❌ [POKEBALL_SPRITE] Animación no encontrada: %s" % nombre_animacion)

## Reproduce la animación completa de captura (abierta -> cerrada -> abierta).
## Perfecto para la batalla.
func animar_captura(nombre_ball: String, callback: Callable = Callable()) -> void:
	if not NOMBRES_POKEBALL.has(nombre_ball):
		print("❌ [POKEBALL_SPRITE] Tipo de Pokéball desconocido: %s" % nombre_ball)
		return

	tipo_actual = NOMBRES_POKEBALL[nombre_ball]
	reproduciendo_captura = true

	var nombre_animacion = nombre_ball.to_lower()
	if sprite_frames.has_animation(nombre_animacion):
		# Configurar velocidad de animación para captura
		sprite_frames.set_animation_speed(nombre_animacion, 8.0)  # 8 FPS para animación suave
		sprite_frames.set_animation_loop(nombre_animacion, false)  # Sin loop

		play(nombre_animacion)

		# Conectar señal de finalización si hay callback
		if callback.is_valid():
			animation_finished.connect(_on_captura_terminada.bind(callback), CONNECT_ONE_SHOT)

		print("🎬 [POKEBALL_SPRITE] Animando captura con %s" % nombre_ball)
	else:
		print("❌ [POKEBALL_SPRITE] Animación no encontrada: %s" % nombre_animacion)

## Muestra la Pokéball en estado cerrado (frame 0) sin animación.
## Útil para la pantalla de información.
func mostrar_estado_estatico(nombre_ball: String) -> void:
	mostrar_pokeball(nombre_ball, EstadoAnimacion.CERRADA)

## Devuelve el tipo de Pokéball actualmente mostrado.
func get_tipo_actual() -> TipoPokeball:
	return tipo_actual

## Devuelve el nombre del tipo de Pokéball actual.
func get_nombre_tipo_actual() -> String:
	for nombre in NOMBRES_POKEBALL:
		if NOMBRES_POKEBALL[nombre] == tipo_actual:
			return nombre
	return "POKEBALL"

# --- CALLBACKS PRIVADOS ---

## Callback privado cuando termina la animación de captura.
func _on_captura_terminada(callback: Callable) -> void:
	reproduciendo_captura = false
	print("✅ [POKEBALL_SPRITE] Animación de captura completada")

	if callback.is_valid():
		callback.call()

# --- FUNCIONES DE UTILIDAD ---

## Convierte el nombre de un objeto (como encuentro_bola) al nombre de Pokéball.
## Útil para mostrar la ball correcta basada en los datos del Pokémon.
static func obtener_pokeball_de_objeto(nombre_objeto: String) -> String:
	var mapeo_objetos = {
		"POKE BALL": "POKEBALL",
		"POKEBALL": "POKEBALL",
		"GREAT BALL": "GREATBALL",
		"GREATBALL": "GREATBALL",
		"ULTRA BALL": "ULTRABALL",
		"ULTRABALL": "ULTRABALL",
		"REPEAT BALL": "REPEATBALL",
		"REPEATBALL": "REPEATBALL",
		"DIVE BALL": "DIVEBALL",
		"DIVEBALL": "DIVEBALL",
		"PREMIER BALL": "PREMIERBALL",
		"PREMIERBALL": "PREMIERBALL",
		"LUXURY BALL": "LUXURYBALL",
		"LUXURYBALL": "LUXURYBALL",
		"NET BALL": "NETBALL",
		"NETBALL": "NETBALL",
		"MASTER BALL": "MASTERBALL",
		"MASTERBALL": "MASTERBALL",
		"NEST BALL": "NESTBALL",
		"NESTBALL": "NESTBALL",
		"SAFARI BALL": "SAFARIBALL",
		"SAFARIBALL": "SAFARIBALL",
		"TIMER BALL": "TIMERBALL",
		"TIMERBALL": "TIMERBALL"
	}

	var nombre_normalizado = nombre_objeto.to_upper().strip_edges()
	return mapeo_objetos.get(nombre_normalizado, "POKEBALL")

## Crea un SpriteFrames configurado para las Pokéballs.
## Útil para configurar automáticamente el recurso.
static func crear_spriteframes_pokeballs() -> SpriteFrames:
	var frames_pokeballs = SpriteFrames.new()

	# Cargar la textura principal
	var textura_pokeballs = load("res://graficos/pokeballs_sprite_sheet.png")  # Ajusta la ruta
	if not textura_pokeballs:
		print("❌ No se pudo cargar la textura de Pokéballs")
		return frames_pokeballs

	# Configurar cada animación
	var nombres_balls = ["pokeball", "greatball", "ultraball", "repeatball", "diveball",
						 "premierball", "luxuryball", "netball", "masterball",
						 "nestball", "safariball", "timerball"]

	for i in range(nombres_balls.size()):
		var nombre_animacion = nombres_balls[i]
		frames_pokeballs.add_animation(nombre_animacion)
		frames_pokeballs.set_animation_speed(nombre_animacion, 1.0)  # Velocidad por defecto
		frames_pokeballs.set_animation_loop(nombre_animacion, true)   # Loop por defecto

		# Añadir los 3 frames de cada ball
		for frame_x in range(3):
			var atlas_texture = AtlasTexture.new()
			atlas_texture.atlas = textura_pokeballs
			atlas_texture.region = Rect2(frame_x * 16, i * 16, 16, 16)
			frames_pokeballs.add_frame(nombre_animacion, atlas_texture)

	print("✅ SpriteFrames de Pokéballs creado con %d animaciones" % nombres_balls.size())
	return frames_pokeballs

# --- HERRAMIENTAS PARA EL EDITOR ---

## Configura los metadatos para la ruta de la textura de Pokéballs.
## Útil para configurar desde el editor de escenas.
func configurar_metadatos_textura(ruta_textura: String) -> void:
	set_meta("pokeball_texture_path", ruta_textura)
	print("📝 [POKEBALL_SPRITE] Metadatos configurados: textura en %s" % ruta_textura)

## Obtiene la ruta de la textura actualmente configurada.
func obtener_ruta_textura_actual() -> String:
	if has_meta("pokeball_texture_path"):
		return get_meta("pokeball_texture_path")

	# Intentar extraer de SpriteFrames existente
	if sprite_frames:
		var animaciones = sprite_frames.get_animation_names()
		if animaciones.size() > 0:
			var primera_animacion = animaciones[0]
			if sprite_frames.get_frame_count(primera_animacion) > 0:
				var primer_frame = sprite_frames.get_frame_texture(primera_animacion, 0)
				if primer_frame is AtlasTexture:
					return primer_frame.atlas.resource_path

	return ""

# func regenerar_animaciones() -> void:
# 	"""
# 	Regenera todas las animaciones desde la textura actual.
# 	Útil para actualizar después de cambios en la imagen.
# 	"""
# 	print("🔄 [POKEBALL_SPRITE] Regenerando animaciones...")
# 	auto_configurar_desde_escena()

## Devuelve información de debug sobre el estado actual del sprite.
func debug_info() -> Dictionary:
	var info = {
		"texture_path": obtener_ruta_textura_actual(),
		"has_metadata": has_meta("pokeball_texture_path"),
		"spriteframes_configured": sprite_frames != null,
		"animations_count": 0,
		"available_animations": []
	}

	if sprite_frames:
		var animaciones = sprite_frames.get_animation_names()
		info.animations_count = animaciones.size()
		info.available_animations = animaciones

	return info
