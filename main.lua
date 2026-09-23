local loadTileset = require "loaders.LoadTileset" local tile_map, rotation_map = unpack(require "map")
local map_batch, tile_quads, tile_size
local camera = love.math.newTransform()

local function load_tiles()
	map_batch, tile_quads, tile_size, _ = loadTileset("asset/tileset.tsx")
end

local function update_map_batch()
	map_batch:clear()
	for row=1,  #tile_map do
		for col=1,  #tile_map[row] do
			map_batch:add(tile_quads[tile_map[row][col]], row*tile_size, col*tile_size, rotation_map[row][col])
		end
	end
	map_batch:flush()
end

---@override
function love.load()
	load_tiles()
	update_map_batch()
	camera:translate(0,0)
	camera:scale(1)
end

---@override
function love.draw()
	love.graphics.applyTransform(camera)
	love.graphics.draw(map_batch)
end

---@override
function love.keypressed(key, unicode)
	love.event.quit()
end
