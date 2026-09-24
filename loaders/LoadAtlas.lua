local xml2lua = require "libs.xml2lua"
local handler = require "libs.xmltree"

return function(atlasPath)
	local atlasFile = io.open(atlasPath, "r")
	local atlasString = atlasFile:read("*all")
	local parser = xml2lua.parser(handler)
	parser:parse(atlasString)
	local xoffset = 10
	local yoffset = 10

	-- Create Spritebatch
	local imageInfo = handler.root.TextureAtlas._attr
	local texturePath = atlasPath:sub(0, atlasPath:match'^.*()/') .. imageInfo.imagePath
	local texture = love.graphics.newImage(texturePath)
	local spriteBatch = love.graphics.newSpriteBatch(texture, 100, "dynamic")

	-- Create Quads
	local quads = {}
	local sprite
	for k,v in pairs(handler.root.TextureAtlas.SubTexture) do
		if type(v) == "table" then
			sprite = v._attr
			quads[sprite.name] = love.graphics.newQuad(sprite.x, sprite.y, sprite.width, sprite.height, imageInfo.width, imageInfo.height)
		end
	end

	return spriteBatch, quads
end
