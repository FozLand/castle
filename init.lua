local load_time_start = os.clock()

--dofile(minetest.get_modpath("castle").."/pillars.lua")
dofile(minetest.get_modpath("castle").."/arrowslit.lua")
dofile(minetest.get_modpath("castle").."/tapestry.lua")
dofile(minetest.get_modpath("castle").."/jailbars.lua")
dofile(minetest.get_modpath("castle").."/town_item.lua")
dofile(minetest.get_modpath("castle").."/shields_decor.lua")
dofile(minetest.get_modpath("castle").."/murder_hole.lua")
--dofile(minetest.get_modpath("castle").."/orbs.lua")
dofile(minetest.get_modpath("castle").."/rope.lua")
--dofile(minetest.get_modpath("castle").."/crossbow.lua")

minetest.register_node("castle:stonewall", {
	description = "Castle Wall",
	drawtype = "normal",
	tiles = {"castle_stonewall.png"},
	paramtype = "light",
	drop = "castle:stonewall",
	groups = {cracky=3},
	sunlight_propagates = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("castle:rubble", {
	description = "Castle Rubble",
	drawtype = "normal",
	tiles = {"castle_rubble.png"},
	paramtype = "light",
	groups = {crumbly=3,falling_node=1},
	sounds = default.node_sound_gravel_defaults(),
})

minetest.register_craft({
	output = "castle:stonewall 2",
	recipe = {
		{"default:cobble"},
		{"default:desert_stone"},
	}
})

minetest.register_craft({
	output = "castle:rubble",
	recipe = {
		{"castle:stonewall"},
	}
})

minetest.register_craft({
	output = "castle:rubble 2",
	recipe = {
		{"default:gravel"},
		{"default:desert_stone"},
	}
})

minetest.register_node("castle:stonewall_corner", {
	drawtype = "normal",
	paramtype = "light",
	paramtype2 = "facedir",
	description = "Castle Corner",
	tiles = {"castle_corner_stonewall_tb.png^[transformR90",
		 "castle_corner_stonewall_tb.png^[transformR180",
		 "castle_corner_stonewall1.png",
		 "castle_stonewall.png",
		 "castle_stonewall.png",	
		 "castle_corner_stonewall2.png"},
	groups = {cracky=3},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_craft({
	output = "castle:stonewall_corner",
	recipe = {
		{"", "castle:stonewall"},
		{"castle:stonewall", "default:sandstone"},
	}
})

minetest.register_node("castle:roofslate", {
	drawtype = "raillike",
	description = "Roof Slates",
	inventory_image = "castle_slate.png",
	paramtype = "light",
	walkable = false,
	tiles = {'castle_slate.png'},
	climbable = true,
	selection_box = {
		type = "fixed",
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {cracky=3,attached_node=1},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("castle:hides", {
	drawtype = "signlike",
	description = "Hides",
	inventory_image = "castle_hide.png",
	paramtype = "light",
	walkable = false,
	tiles = {'castle_hide.png'},
	climbable = true,
	paramtype2 = "wallmounted",
	legacy_wallmounted = true,
	groups = {dig_immediate=2},
	selection_box = {
		type = "wallmounted",
	},
})

minetest.register_craft( {
	type = "shapeless",
	output = "castle:hides 6",
	recipe = { "wool:white" , "bucket:bucket_water" },
	replacements = {
		{ 'bucket:bucket_water', 'bucket:bucket_empty' }
	}
})

local mod_building_blocks = minetest.get_modpath("building_blocks")
local mod_streets = minetest.get_modpath("streets") or minetest.get_modpath("asphalt")

if mod_building_blocks then
	minetest.register_craft({
		output = "castle:roofslate 4",
		recipe = {
			{ "building_blocks:Tar" , "default:gravel" },
			{ "default:gravel",       "building_blocks:Tar" }
		}
	})

	minetest.register_craft( {
		output = "castle:roofslate 4",
		recipe = {
			{ "default:gravel",       "building_blocks:Tar" },
			{ "building_blocks:Tar" , "default:gravel" }
		}
	})
end

if mod_streets then
	minetest.register_craft( {
		output = "castle:roofslate 4",
		recipe = {
			{ "streets:asphalt" , "default:gravel" },
			{ "default:gravel",   "streets:asphalt" }
		}
	})

	minetest.register_craft( {
		output = "castle:roofslate 4",
		recipe = {
			{ "default:gravel",   "streets:asphalt" },
			{ "streets:asphalt" , "default:gravel" }
		}
	})
end

if not (mod_building_blocks or mod_streets) then
	minetest.register_craft({
		type = "cooking",
		output = "castle:roofslate",
		recipe = "default:gravel",
	})

end

doors.register("castle:oak_door", {
	tiles = {{ name = "castle_door_oak.png", backface_culling = true }},
	description = "Oak Door",
	inventory_image = "castle_oak_door_inv.png",
	protected = true,
	groups = { choppy = 2, door = 1 },
	sounds = default.node_sound_wood_defaults(),
	recipe = {
		{"default:tree", "default:tree"},
		{"default:tree", "default:tree"},
		{"default:tree", "default:tree"},
	}
})

doors.register("castle:jail_door", {
	tiles = {{ name = "castle_door_jail.png", backface_culling = true }},
	description = "Jail Door",
	inventory_image = "castle_jail_door_inv.png",
	protected = true,
	groups = { cracky = 2, door = 1},
	sound_open = "doors_steel_door_open",
	sound_close = "doors_steel_door_close",
	recipe = {
		{"castle:jailbars", "castle:jailbars"},
		{"castle:jailbars", "castle:jailbars"},
		{"castle:jailbars", "castle:jailbars"},
	}
})

function default.get_ironbound_chest_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[8,9]"..
		default.gui_bg ..
		default.gui_bg_img ..
		default.gui_slots ..
		"list[nodemeta:".. spos .. ";main;0,0;8,4;]"..
		"list[current_player;main;0,5;8,4;]"
	return formspec
end

local function has_ironbound_chest_privilege(meta, player)
	local name = ""
	if player then
		if minetest.check_player_privs(player, "protection_bypass") then
			return true
		end
		name = player:get_player_name()
	end
	if name ~= meta:get_string("owner") then
		return false
	end
	return true
end

minetest.register_node("castle:ironbound_chest",{
	drawtype = "nodebox",
	description = "Ironbound Chest",
	tiles = {"castle_ironbound_chest_top.png",
			"castle_ironbound_chest_top.png",
			"castle_ironbound_chest_side.png",
			"castle_ironbound_chest_side.png",
			"castle_ironbound_chest_back.png",
			"castle_ironbound_chest_front.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {cracky=2},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.500000,-0.500000,-0.312500,0.500000,-0.062500,0.312500},
			{-0.500000,-0.062500,-0.250000,0.500000,0.000000,0.250000},
			{-0.500000,0.000000,-0.187500,0.500000,0.062500,0.187500},
			{-0.500000,0.062500,-0.062500,0.500000,0.125000,0.062500},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.500000,-0.400000,0.5,0.200000,0.4},

		},
	},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Ironbound Chest (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Ironbound Chest")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_ironbound_chest_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_ironbound_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a ironbound chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_ironbound_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a ironbound chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_ironbound_chest_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a ironbound chest belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local who   = player:get_player_name()
		local what  = " moves stuff in ironbound chest"
		local where = " at "..core.pos_to_string(pos)
		minetest.log("action", who..what..where)
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		local who   = player:get_player_name()
		local stuff = stack:get_count().." "..stack:get_name()
		local what  = " puts "..stuff.." in ironbound chest"
		local where = " at "..core.pos_to_string(pos)
		minetest.log("action", who..what..where)
	end,
	on_metadata_inventory_take = function(pos, listname, index, stack, player)
		local who   = player:get_player_name()
		local stuff = stack:get_count().." "..stack:get_name()
		local what  = " takes "..stuff.." from ironbound chest"
		local where = " at "..core.pos_to_string(pos)
		minetest.log("action", who..what..where)
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if has_ironbound_chest_privilege(meta, clicker) then
			minetest.show_formspec(
				clicker:get_player_name(),
				"castle:ironbound_chest",
				default.get_ironbound_chest_formspec(pos)
			)
		end
	end,
	on_blast = function() end,
})

minetest.register_craft({
	output = "castle:ironbound_chest",
	recipe = {
		{"group:wood", "default:steel_ingot","group:wood"},
		{"group:wood", "default:steel_ingot","group:wood"}
	}
})

minetest.register_tool("castle:battleaxe", {
	description = "Battleaxe",
	inventory_image = "castle_battleaxe.png",
	tool_capabilities = {
		full_punch_interval = 2.0,
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=2.10, [2]=0.90, [3]=0.50}, uses=20, maxlevel=3},
			snappy={times={[1]=1.90, [2]=0.90, [3]=0.30}, uses=20, maxlevel=3},
		},
		damage_groups = {fleshy=7},
	},
})

minetest.register_craft({
	output = "castle:battleaxe",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot","default:steel_ingot"},
		{"default:steel_ingot", "default:stick","default:steel_ingot"},
		{"", "default:stick",""}
	}
})

if minetest.get_modpath("moreblocks") then
	stairsplus:register_all("castle", "stonewall", "castle:stonewall", {
		description = "Stone Wall",
		tiles = {"castle_stonewall.png"},
		groups = {cracky=3, not_in_creative_inventory=1},
		sounds = default.node_sound_stone_defaults(),
		sunlight_propagates = true,
	})

	stairsplus:register_all("castle", "rubble", "castle:rubble", {
		description = "Rubble",
		tiles = {"castle_rubble.png"},
		groups = {cracky=3, not_in_creative_inventory=1},
		sounds = default.node_sound_gravel_defaults(),
		sunlight_propagates = true,
	})

else
	stairs.register_stair_and_slab("stonewall", "castle:stonewall",
		{cracky=3},
		{"castle_stonewall.png"},
		"Castle Stonewall Stair",
		"Castle Stonewall Slab",
		default.node_sound_stone_defaults()
	)

	stairs.register_stair_and_slab("rubble", "castle:rubble",
		{cracky=3},
		{"castle_rubble.png"},
		"Castle Rubble Stair",
		"Castle Rubble Slab",
		default.node_sound_stone_defaults()
	)
end

if minetest.setting_get("log_mods") then
	minetest.log('action', string.format('['..minetest.get_current_modname()..']'..
			' loaded in %.3fs', os.clock() - load_time_start))
end
