-- Vita Sokoban by Harommel OddSock

e = timer.new()

help = false
psexchar = font.load("sa0:data/font/pvf/psexchar.pvf")

white  = color.new(255, 255, 255)
black  = color.new(0, 0, 0)
blue   = color.new(0, 0, 255)
yellow = color.new(255, 255, 0)
brown  = color.new(150, 75, 0)
green = color.new(0, 255, 0, 255/2)

W = white   -- wall
E = black   -- empty
P = blue    -- player
T = green  -- target
B = brown   -- box
X = yellow  -- box on target

function controls.rfheld(button, time)
    if not rf_ticks then rf_ticks = {} end
    if rf_ticks[button] == nil then
        rf_ticks[button] = 0
    end

    if controls.pressed(button) then
        rf_ticks[button] = 0
        return true
    elseif controls.held(button) then
        rf_ticks[button] = rf_ticks[button] + 1
        if rf_ticks[button] >= time then
            rf_ticks[button] = 0
            return true
        end
    else
        rf_ticks[button] = 0
    end

    return false
end

function parse_secs(secs)
 local hours = math.floor(secs / 3600)
 local minutes = math.floor((secs % 3600) / 60)
 local seconds = math.floor(secs % 60)
 local ms = math.floor((secs * 1000) % 1000)
 return string.format("%02d:%02d:%02d:%03d", hours, minutes, seconds, ms)
end
--[[
music_playlist, musaud = json.parse(io.open("app0:music.json", "r"):read("*all")) or {}, {}
for i = 1, #music_playlist do
if music_playlist[i] ~= "" then musaud[i] = audio.load(music_playlist[i]) end
end
]]
-- levels
dofile("levels.lua")
l_i = 1
level = levels[l_i]

-- libs
dofile("grid.lua")
dofile("player.lua")
dofile("history.lua")

original_level = grid.copy(level)

local b_c = grid.count(B)

--curr_i = 1

function endg(i)
e:stop()
os.message("You have reached the end!\n"..#levels.." levels in total\n"..parse_secs(e:elapsed()).." elapsed")
--if musaud[curr_i]:playing() then musaud[curr_i]:stop() end
os.exit()
end

function levelswitch(i)
if level == levels[i] then state.restore(1) else
level = levels[i] or --[[error("Level "..i.." not found")]] endg()
original_level = nil
original_level = grid.copy(level)
player.x, player.y, player.moves = 1, 1, 0
for y = 1, #level do
    for x = 1, #level[y] do
        if level[y][x] == P then
            player.x = x
            player.y = y
        end
    end
end
b_c = grid.count(B)
history, state.index = {}, 0
state.save()
end
end

t = timer.new()
e:start()

while true do
--[[if not musaud[curr_i]:playing() then
musaud[curr_i]:stop()
curr_i = curr_i + 1
musaud[curr_i]:play()
end]]
    draw.text(10, 10, "X: "..(player.x-1)..", Y: "..(player.y-1), white)
    draw.text(10, 30, "Blocks on targets: "..grid.count(X).."/"..b_c, white)
    draw.text(10, 50, "Moves: "..player.moves, white)
    draw.text(10, 70, "Step: "..(state.index-1).."/"..(#history-1), white)
    draw.text(10, 90, "Level: "..l_i.."/"..#levels, white)
    draw.text(960-draw.textwidth(parse_secs(e:elapsed()))-10, 10, parse_secs(e:elapsed()), white)
    grid.draw(level)
    controls.update()
if not help then
    if controls.rfheld(SCE_CTRL_UP, 8) then player.move(0, -1) end
    if controls.rfheld(SCE_CTRL_DOWN, 8) then player.move(0, 1) end
    if controls.rfheld(SCE_CTRL_LEFT, 8) then player.move(-1, 0) end
    if controls.rfheld(SCE_CTRL_RIGHT, 8) then player.move(1, 0) end
    if controls.pressed(SCE_CTRL_SELECT) then state.restore(1) end
    if controls.rfheld(SCE_CTRL_LTRIGGER, 8) then state.restore(state.index - 1) end
    if controls.rfheld(SCE_CTRL_RTRIGGER, 8) then state.restore(state.index + 1) end
    if controls.released(SCE_CTRL_START) then break end
end
    if b_c == grid.count(X) then if not t:running() then t:start() end if t:elapsed() >= 1 then l_i = l_i + 1 levelswitch(l_i) t:stop() end end
    if controls.pressed(SCE_CTRL_TRIANGLE) then if help then e:pause() help = false else help = true end end

if help then
if e:running() then e:pause() end
draw.rect(480/2, 272/2, 480, 272, black, white)
draw.text((480/2)+10, (272/2)+10, ",-./", white, psexchar)
draw.text((480/2)+10+draw.textwidth(",-./", psexchar), (272/2)+10, " Move", white)
draw.text((480/2)+10, (272/2)+10+20, "01", white, psexchar)
draw.text((480/2)+10+draw.textwidth("01", psexchar), (272/2)+10+20, " Rewind/Fast-Forward", white)
draw.text((480/2)+10, (272/2)+10+40, "4", white, psexchar)
draw.text((480/2)+10+draw.textwidth("4", psexchar), (272/2)+10+40, " Reset", white)
draw.text((480/2)+10, (272/2)+10+60, "5", white, psexchar)
draw.text((480/2)+10+draw.textwidth("5", psexchar), (272/2)+10+60, " Exit", white)
draw.text((480/2)+10, (272/2)+10+80, " ", white, psexchar)
draw.text((480/2)+10+draw.textwidth(" ", psexchar), (272/2)+10+80, " Help", white)
end

    draw.swapbuffers()
end

--if musaud[curr_i]:playing() then musaud[curr_i]:stop() end
