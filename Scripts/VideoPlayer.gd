extends VideoPlayer

onready var albumLabel = get_node("AlbumLabel")

var font = load("res://Fonts/font.tres")
const fontYOffset = 10.0

var videos = []
var currentVideo = 0

var windowSize = Vector2(ProjectSettings.get("display/window/size/width"), ProjectSettings.get("display/window/size/height"))
var windowWidth = ProjectSettings.get("display/window/size/width")
var windowHeight = ProjectSettings.get("display/window/size/height")

const artTargetHeight = 220.0
const artPadding = 18.0
const fontWPadding = 8.0
const minInfoArtWidth = 500.0
const progressBarHeight = 15.0
var musicInfo = null

var infoYTarget = artTargetHeight * 1.17

var transition = false
var absoluteBoxAlpha = 0.0
var videoBoxAlpha = 0.0
var infoBoxAlpha = 0.3

var infoBox = load("res://Textures/InfoBackground.png")

var stopped = false

var audioPosition = 0.0001
var audioLength = 0.0001

func _ready():
	set_size(windowSize + Vector2(50,50))
	pass

func _process(delta):
	update()
	if(!is_playing()):
		play()
		pass
	pass

func _draw():
	#VideoBox
	draw_colored_polygon(PoolVector2Array([Vector2(0,0),Vector2(windowWidth,0),Vector2(windowWidth,windowHeight),Vector2(0,windowHeight)]),Color(0,0,0,videoBoxAlpha))
	#Draw art section
	if(musicInfo):
		var artWidth = musicInfo.art.get_width() * (artTargetHeight / musicInfo.art.get_height()) 
		var artPosition = Vector2(artPadding, artPadding)
		
		#InfoBox
		var musicNameWidth = albumLabel.get_font("font").get_string_size(musicInfo.name).x
		var albumNameWidth = albumLabel.get_font("font").get_string_size(musicInfo.album).x
		var textWidth = musicNameWidth if musicNameWidth > albumNameWidth else albumNameWidth
		var infoBoxWidthTest = artWidth + artPadding + fontWPadding + textWidth + (textWidth * 0.08)
		var infoBoxWidth = infoBoxWidthTest if infoBoxWidthTest > minInfoArtWidth else minInfoArtWidth
		draw_texture_rect(infoBox,Rect2(Vector2(0,0), Vector2(infoBoxWidth + 15.0, infoYTarget)),false,Color(1,1,1,infoBoxAlpha))
		#Art
		draw_texture_rect(musicInfo.art, Rect2(artPosition,Vector2(artWidth, artTargetHeight)),false,Color(1,1,1,1))
		#String
		draw_string(font,Vector2(artWidth + artPadding + fontWPadding, artTargetHeight - fontWPadding - albumLabel.get_line_height() + fontYOffset),musicInfo.name, Color(0.92,0.92,0.92,1))
		draw_string(font,Vector2(artWidth + artPadding + fontWPadding, artTargetHeight - fontWPadding + fontYOffset),musicInfo.album, Color(0.83,0.83,0.83,1))
		#Progress Bar
		var progressBarWidth = (audioPosition / audioLength) * windowWidth
		draw_colored_polygon(PoolVector2Array([Vector2(0,windowHeight),Vector2(0,windowHeight - progressBarHeight),Vector2(progressBarWidth,windowHeight - progressBarHeight),Vector2(progressBarWidth,windowHeight)]),Color(0.45,0.45,0.45,0.6))
		pass
	#AbsoluteBox
	draw_colored_polygon(PoolVector2Array([Vector2(0,0),Vector2(windowWidth,0),Vector2(windowWidth,windowHeight),Vector2(0,windowHeight)]),Color(0,0,0,absoluteBoxAlpha))
	pass
