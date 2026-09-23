local xml2lua = require "libs.xml2lua"
local handler = require "libs.xmltree"

return function(tilesetPath)
	local tilesetFile = io.open(tilesetPath, "r")
	local tilesetString = tilesetFile:read("*all")
	local parser = xml2lua.parser(handler)
	parser:parse(tilesetString)


	-- Creat Spritebatch
	local tilesetInfo = handler.root.tileset._attr
	local imageInfo = handler.root.tileset.image._attr
	local texturePath = tilesetPath:sub(0, tilesetPath:match'^.*()/') .. imageInfo.source
	local texture = love.graphics.newImage(texturePath)
	local spriteBatch = love.graphics.newSpriteBatch(texture, 100, "dynamic")

	-- Creat Quads
	local quads = {}
	for x=0, tilesetInfo.tilecount do
		local column = math.fmod(x, tilesetInfo.columns) 	
		local row = math.floor(x/tilesetInfo.columns)
		width = tilesetInfo.tilewidth
		height = tilesetInfo.tileheight
		local x = column * (width + tilesetInfo.spacing)
		local y = row * (height + tilesetInfo.spacing)
		table.insert(quads, love.graphics.newQuad(x, y, width, height, imageInfo.width, imageInfo.height))
	end	

	return spriteBatch, quads, width, height
end
