--[[

this is not very well documented and a mess. DONT HATE ME PLEASE.
uses Love2D for "gui".
pitches expressed in semitones, frequencies in Hz.


main.lua has all the gui stuff, convert.lua does the conversion.
]]

require("convert")

msg = false

io.stdout:setvbuf("no")

width = 500
height = 400

love.window.setMode(width, height)
love.window.setTitle( "Scala to 0CC converter" )


function love.load()
	font = love.graphics.newFont(16)
	font_small = love.graphics.newFont(12)
end

function love.filedropped( file ) 
	convertFile(file)
end

function love.draw(...)
	love.graphics.setFont(font)

	love.graphics.setBackgroundColor(0.05,0.0,0.1)
	love.graphics.setColor(0.8,1.0,0.8)
	love.graphics.printf("Drop your scala file here!",0,100,width,"center")
	if(msg) then
		love.graphics.printf(msg,0,150,width,"center")
	elseif(filename) then
		love.graphics.printf("Generated file! (" .. filename .. ")",0,150,width,"center")
	end

	love.graphics.setFont(font_small)
	love.graphics.printf("#channels N163: ".. N163_nch,20,height-40,width,"left")
	love.graphics.printf("xoxox ya boy Sintel",0,height-40,width-20,"right")
end

function love.keypressed(key, isrepeat)
	if(key == 'escape') then
		love.event.quit()
	elseif(key == '1') then
		N163_nch = 1
	elseif(key == '2') then
		N163_nch = 2
	elseif(key == '3') then
		N163_nch = 3
	elseif(key == '4') then
		N163_nch = 4
	elseif(key == '5') then
		N163_nch = 5
	elseif(key == '6') then
		N163_nch = 6
	elseif(key == '7') then
		N163_nch = 7
	elseif(key == '8') then
		N163_nch = 8
	end
end