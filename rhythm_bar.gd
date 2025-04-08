extends Node2D

@onready var north = $North
@onready var east = $East  
@onready var south = $South
@onready var west = $West  

# Rhythm bar settings
var radius = 45.0
var speed = 0.8
var angle = 0.0
var bar_end = Vector2.ZERO
var position_offset = Vector2(75, 75)  # Center of SubViewport

# Highlight color (blue)
var highlight_color = Color(0.3, 0.6, 1.0, 0.8)  # Blue highlight with transparency

func _ready():
	print("RhythmBar _ready() called")
	position = position_offset
	bar_end = Vector2(0, -radius)

	# Apply consistent icon sizing and positioning
	apply_custom_icon_scales()
	position_icons()

	# Make absolutely sure we're visible
	modulate = Color(1, 1, 1, 1)
	z_index = 100

func apply_custom_icon_scales():
	# Target size in pixels (how big you want all icons to be)
	var target_size = 16.0  # Adjust this value to your preference

	# Handle each icon by directly measuring its texture
	if north and north.texture:
		var tex_size = north.texture.get_size()
		north.scale = Vector2(target_size/tex_size.x, target_size/tex_size.y)

	if east and east.texture:
		var tex_size = east.texture.get_size()
		east.scale = Vector2(target_size/tex_size.x, target_size/tex_size.y)

	if south and south.texture:
		var tex_size = south.texture.get_size()
		south.scale = Vector2(target_size/tex_size.x, target_size/tex_size.y)

	if west and west.texture:
		var tex_size = west.texture.get_size()
		west.scale = Vector2(target_size/tex_size.x, target_size/tex_size.y)

	# Print debug info
	print("Icon scales applied")

func position_icons():
	if north: 
		north.position = Vector2(0, -radius - 10)
	if east: 
		east.position = Vector2(radius + 10, 0)
	if south: 
		south.position = Vector2(0, radius + 10)
	if west: 
		west.position = Vector2(-radius - 10, 0)

func _draw():
	# Draw circle background
	draw_circle(Vector2.ZERO, radius, Color(0.3, 0.3, 0.3, 0.7))

	# White outline
	draw_arc(Vector2.ZERO, radius, 0, 2*PI, 32, Color.WHITE, 3.0)

	# Draw the rotating bar (blue to match highlight)
	draw_line(Vector2.ZERO, bar_end, Color(0.3, 0.6, 1.0, 1.0), 3.0)  # Blue, matching highlight

	# End dot
	draw_circle(bar_end, 6.0, Color(0.3, 0.6, 1.0, 1.0))  # Blue dot

	# Draw highlights behind active icon
	draw_active_highlight()

	# Small dot at center for reference
	draw_circle(Vector2.ZERO, 2.0, Color.WHITE)

func draw_active_highlight():
	# Get angle in degrees
	var degrees = rad_to_deg(angle)

	# Highlight radius
	var highlight_radius = 20

	# Draw a highlight circle behind the active icon
	if (degrees >= 315 or degrees < 45) and north:
		draw_circle(north.position, highlight_radius, highlight_color)
	elif degrees >= 45 and degrees < 135 and east:
		draw_circle(east.position, highlight_radius, highlight_color)
	elif degrees >= 135 and degrees < 225 and south:
		draw_circle(south.position, highlight_radius, highlight_color)
	elif degrees >= 225 and degrees < 315 and west:
		draw_circle(west.position, highlight_radius, highlight_color)

func _process(delta):
	# Update angle
	angle += speed * delta

	# Keep angle in range
	while angle >= 2 * PI:
		angle -= 2 * PI

	# Calculate bar position directly
	bar_end = Vector2(sin(angle) * radius, -cos(angle) * radius)

	# Redraw (which includes the highlight)
	queue_redraw()
