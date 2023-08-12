local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

-- Replace all trees within a chunk.
local function replace_trees(event)
    local surface = event.surface

    if surface.name ~= "nauvis" then
        -- "nauvis" for compatibility with Factorissimo
        return
    end

    local entities = surface.find_entities_filtered{area = event.area, type = 'tree'}
    for _, tree in pairs(entities) do
        if starts_with(tree.name, "tree") == false then
            goto continue
        end

        local rand = global.rng(0, 2);

        if ends_with(tree.name, "red") then
            surface.create_entity{name = 'tree-02-red', position = tree.position}
        else
            if rand == 0 then
                surface.create_entity{name = 'tree-02', position = tree.position}
            end
            if rand == 1 then
                surface.create_entity{name = 'tree-05', position = tree.position}
            end
            if rand == 2 then
                surface.create_entity{name = 'tree-07', position = tree.position}
            end
        end

        tree.destroy()
        ::continue::
    end
end

-- Runs on mod initialization.
local function on_init(_)
    global.rng = game.create_random_generator()
end

script.on_init(on_init)
script.on_event(defines.events.on_chunk_generated, replace_trees)
