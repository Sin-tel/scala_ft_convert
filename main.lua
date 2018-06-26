--[[

this is not very well documented and a mess. DONT HATE ME PLEASE.
uses Love2D for "gui".
pitches expressed in semitones, frequencies in Hz.

]]

io.stdout:setvbuf("no")

width = 500
height = 400
love.window.setMode(width, height)
love.window.setTitle( "Scala to 0CC converter" )


--1.789773MHz NTSC, 1.662607MHz PAL
CPU_NTSC = 1789773
CPU_PAL  = 1662607

N163_nch = 4
N163_len = 32 -- cant change this for now

chips = {'NTSC', 'PAL', 'Saw', 'VRC7', 'FDS', 'N163'}

msg = false

function love.load()
	font = love.graphics.newFont(16)
	font_small = love.graphics.newFont(12)
end

function love.filedropped( file ) 
	msg = false
	if not pcall(loadFile,file) then
		msg = 'Error: unsupported file!'
	else
		file_tun = io.open(filename, "w")

		t = {}
		for i,chip in ipairs(chips) do
			t[i] = ''
			for octave = 0,7 do
				for pitch = 0,11 do
					local p = octave*12 + pitch
					local p2 = pitchfromscale(p)

					local period_target = pitch2period(p,chip,octave)
					local period = pitch2period(p2,chip,octave)

					local diff = period_target-period
					--print(p, p2, diff)

					t[i] = t[i] .. ',' .. tonumber(diff)
				end
			end
		end

		file_tun:write('0' .. t[1] .. '\n')
		file_tun:write('1' .. t[2] .. '\n')
		file_tun:write('2' .. t[3] .. '\n')
		file_tun:write('3' .. t[4] .. '\n')
		file_tun:write('4' .. t[5] .. '\n')
		file_tun:write('5' .. t[6] .. '\n')

		file_tun:close()
	end
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

function loadFile(file)
	filename = file:getFilename()
	filename = string.match (filename, "([^\\/]-%.?)$")
	filename = string.sub(filename, 1, filename:len()-4) .. '.csv'

	print(filename)

	l = 0
	scale = {}
	for line in file:lines() do 
		--exclude comments
		if string.sub(line, 1, 1) ~= '!' then
			print(line)
			if(l == 1) then
				scale_length = tonumber(line)
			end
			if(l > 1 and string.len(line) > 1) then
				if(string.find(line,'/')) then
					local s = string.find(line,'/')
					local p = tonumber(string.sub(line,1,s-1))
					local q = tonumber(string.sub(line,s+1))

					scale[l-1] = ratio2pitch(p/q)
				else
					scale[l-1] = tonumber(line)/100
				end
				--scale[l-1] = 
			end
			l = l + 1 
		end
	end
	print("---scale:")
	print(scale_length)
	for i = 1,scale_length do
		print(scale[i])
	end
end

--convert pitch to frequency, C3 = 36 = 261.6256 Hz
function pitch2freq(p)
	return 261.6256 * 2^((p-36)/12)
end

--convert frequency to register values
function freq2period(f,chip,oct)
	local per = 0
	if(chip == 'NTSC') then
		per = (CPU_NTSC/ (16*f)) - 1
	elseif(chip == 'PAL') then
		per = (CPU_PAL/ (16*f)) - 1
	elseif(chip == 'Saw') then
		per =  (CPU_NTSC/ (14*f)) - 1
	elseif(chip == 'VRC7') then
		--49716/32768 = 1.51721191406
		--VRC7 is the same each octave. no non-octave tunings >:L
		per = f/(1.51721191406*(2^(oct-3)))
		per = -per
	elseif(chip == 'FDS') then
		per = f*64*65536/CPU_NTSC
		--famitracker inverts the value. division by 4 is ude to octave difference
		per = -per/4
	elseif(chip == 'N163') then
		per = f*15*65536*N163_len*N163_nch/CPU_NTSC
		--famitracker scales the value by -8
		per = -per/8
	end

	return math.floor (per + 0.5)
end

--convert pitch to frequency register
function pitch2period(p,chip,oct)
	local f = pitch2freq(p)
	return freq2period(f,chip,oct)
end

--convert frequency ratio to pitch
function ratio2pitch(r)
	return 12*math.log(r)/math.log(2)
end

--get pitch from scale table
function pitchfromscale(p)
	p = p - 36
	local degree = (p) % scale_length
	local oct = (p - degree)/scale_length

	local pitch = oct*scale[scale_length] + 36
	if(degree > 0) then
		pitch = pitch + scale[degree]
	end
	return pitch
end