local loadTileset = require "loaders.LoadTileset"
local tile_map, rotation_map = unpack(require "map")
local utils = require("utils")
local map_batch, tile_quads, tile_size
local camera = love.math.newTransform()
local UI = require("ui")
local UI_Renderer, Widget = UI.UI_Renderer, UI.Widget

local function load_tiles()
	map_batch, tile_quads, tile_size, _ = loadTileset("asset/tileset.tsx")
end

local function update_map_batch()
	map_batch:clear()
	local half_size = tile_size / 2
	for row=1,  #tile_map do
		for col=1,  #tile_map[row] do
			map_batch:add(
				tile_quads[tile_map[row][col]],
				(col-1)*tile_size + half_size,
				(row-1)*tile_size + half_size,
				rotation_map[row][col],
				1,1,
				half_size, half_size
			)
		end
	end
	map_batch:flush()
end

---@override
function love.load()
	load_tiles()
	update_map_batch()
	camera:translate(70,0)
	camera:scale(2)

	local test = Widget:new()
	UI_Renderer:pushWidget(test)
	UI_Renderer:update()
end

---@override
function love.draw()
	love.graphics.applyTransform(camera)
	-- draw world
	love.graphics.draw(map_batch)

	love.graphics.applyTransform(camera:inverse())
	-- draw UI
	UI_Renderer:render()
end

---@override
function love.keypressed(key, unicode)
	love.event.quit()
end

---@override
function love.mousepressed(x, y, button)
	local worldx, worldy = camera:inverse():transformPoint(x, y)
	local col, row= utils.coords_to_tile(worldx,worldy)
	tile_map[row][col]=43
	update_map_batch()
end
