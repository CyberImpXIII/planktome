--  
--   ////\\\\
--   ////\\\\  PLANTUNE
--   ////\\\\  
--   \\\\////
--   \\\\////  
--   \\\\////
--
engine.name = 'OutputTutorial'

local viewport = { width = 128, height = 64 }
local focus = { x = 0, y = 0 }
local counter = 0
local note_position_one = { x = 8, y = 8 }
local note_storage = { [0] = math.random(30, 2000), [1] = math.random(30, 2000),[2] = math.random(30, 2000), [3] = math.random(30, 2000), [4] = math.random(30, 2000),[5] = math.random(30, 2000),[6] = math.random(30, 2000), [7] = math.random(30, 2000),[8] = math.random(30, 2000),  [9] = math.random(30, 2000),[10] = math.random(30, 2000),[11] = math.random(30, 2000), [12] = math.random(30, 2000),[13]= math.random(30, 2000),[14] = math.random(30, 2000), [15] = math.random(30, 2000)}
local g
local pressed = false
local tone = 900
local step = 7
-- Main

function init()
  connect()
  -- Render Style
  screen.level(15)
  screen.aa(0)
  screen.line_width(1)
  -- Center focus
  reset()
  -- Render
  redraw()
end
function on_grid_add(g)
  print('on_add')
end

function on_grid_remove(g)
  print('on_remove')
end
function reset()
    focus.x = viewport.width/2
  focus.y = viewport.height/2
  end

function arrow_up()
  screen.pixel(focus.x  + 1, focus.y - 1)
  screen.pixel(focus.x  + 1, focus.y + 1)
  screen.pixel(focus.x  + 1, focus.y)
  screen.pixel(focus.x, focus.y)
  screen.pixel(focus.x  - 1, focus.y)
  screen.pixel(focus.x  + 2, focus.y)
  screen.fill()
  screen.clear()
end

function arrow_left()

  screen.pixel(focus.x  - 1, focus.y - 1)
  screen.pixel(focus.x  - 1, focus.y + 1)
  screen.pixel(focus.x  - 1, focus.y)
  screen.pixel(focus.x, focus.y)
  screen.pixel(focus.x  - 1, focus.y)
  screen.pixel(focus.x - 2  , focus.y )
    screen.pixel(focus.x + 1  , focus.y )
  screen.fill()
end

function arrow_right()
      screen.pixel(focus.x + 2  , focus.y )
      screen.pixel(focus.x + 1  , focus.y )
      screen.pixel(focus.x , focus.y )
      screen.pixel(focus.x - 1  , focus.y )
      screen.pixel(focus.x + 1  , focus.y + 1)
      screen.pixel(focus.x + 1  , focus.y - 1)
      screen.fill()
  end

function connect()
  g = grid.connect()
  g.key = on_grid_key
  g.add = on_grid_add
  g.remove = on_grid_remove
end



function update(x, y)
  g:all(0)
  g:led(x, y,15)
  g:refresh()
  redraw()
end

function note_change()
  note_storage[step] = tone
end

-- Interactions

function key(id,state)
  print('key',id,state)
  if id == 3 then
    if state == 0 then
      pressed = false
      note_change()
    elseif state == 1 then
      pressed = true
    end
      print(pressed)
      redraw()
  end
redraw()
end

function enc(id,delta)
  print('enc',id,delta)
  if id == 2 then
    if pressed == true then
    step = clamp(step + delta, 0, 15)
      else
    focus.x= clamp(focus.x + delta,2,123)
    end
  elseif id == 3 then
        if pressed == true then
    tone = clamp(tone + (delta*10), 30, 2000)
      else
    focus.y = clamp(focus.y + delta,2,63)
    end
  end
  redraw()
end

-- Render

function draw_frame()
  screen.rect(1, 1, viewport.width-1, viewport.height-1)
  screen.rect(4,4,8,8)
  screen.rect(14,4,8,8)
  screen.rect(24,4,8,8)
  screen.rect(34,4,8,8)
  screen.rect(4,14,8,8)
  screen.rect(14,14,8,8)
  screen.rect(24,14,8,8)
  screen.rect(34,14,8,8)
  screen.rect(4,24,8,8)
  screen.rect(14,24,8,8)
  screen.rect(24,24,8,8)
  screen.rect(34,24,8,8)
  screen.rect(4,34,8,8)
  screen.rect(14,34,8,8)
  screen.rect(24,34,8,8)
  screen.rect(34,34,8,8)
  screen.stroke()
end

function calc_position()
  note_position_one.x = ((counter%4) * 10) + 8
  note_position_one.y = (math.floor(counter/4) * 10) + 8
end

function draw_crosshair(x_pos, y_pos)
  screen.move(x_pos,y_pos - 4)
  screen.line(x_pos,y_pos - 2)
  screen.move(x_pos - 4, y_pos)
  screen.line(x_pos - 2, y_pos)
  screen.move(x_pos,y_pos + 3)
  screen.line(x_pos,y_pos + 1)
  screen.move(x_pos + 3,y_pos)
  screen.line(x_pos + 1,y_pos)
  screen.stroke()
end

function draw_position()
  screen.move(5,viewport.height - (8 * 1))
  screen.text('step'..(step)..':' ..(tone)..'hz')
end

function draw_number()
  screen.move(5,viewport.height - (16 * 1))
  screen.text(counter)
end

function play_tones()
    engine.hz(note_storage[counter])
  end

re = metro.init()
re.time = 1
re.event = function()
  counter = counter + 1
  if counter > 15 then
    counter = 0
  end
    update((counter%4) + 1, math.ceil((counter+1)/4))
    play_tones()

  redraw()
end
re:start()

function redraw()
  screen.clear()
  calc_position()
  draw_frame()
  draw_crosshair(note_position_one.x, note_position_one.y)
  arrow_right()
  draw_position()
  draw_number()
  screen.update()
end

-- Utils

function clamp(val,min,max)
  return val < min and min or val > max and max or val
end
