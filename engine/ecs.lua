local debug = require('libs.debug')
local ecs = {
    entities = {},
    components = {},
    systems = {},
    world = {}
}


-- Entities

function ecs.createEntity(type, components)
    local entity = {
        type = type,
        id = #ecs.entities + 1,
        components = {}
    }
    for key, value in pairs(components) do
        entity.components[key] = value
    end
    table.insert(ecs.entities, entity)
    return entity
end

function ecs.cloneEntity(entity)
    local newEntity = {
        type = entity.type,
        id = #ecs.entities + 1,
        components = {}
    }
    for key, value in pairs(entity.components) do
        newEntity.components[key] = value
    end
    table.insert(ecs.entities, newEntity)
end

-- Components

function ecs.createComponent(name, data)
    ecs.components[name] = data
end

function ecs.getComponent(name)
    return ecs.components[name]
end

function ecs.addComponent(entity, name, data)
    -- check if the component already exists, if not create it the nadd
    print("Adding component:", name, "to entity:", entity.id)
    if ecs.components[name] == nil then
        ecs.createComponent(name, data)
    end

    if entity.components[name] == nil then
        entity.components[name] = data
    else
        print("Component already exists for entity:", entity.id, "Component:", name)
    end
end

function ecs.clear()
    for _, entity in ipairs(ecs.entities) do
        for name, _ in pairs(entity.components) do
            entity.components[name] = nil
        end
    end
    ecs.entities = {}
end

function ecs.removeComponent(entity, name)
    entity.components[name] = nil
end

function ecs.hasComponent(entity, name)
    return entity.components[name] ~= nil
end

function ecs.getComponentData(entity, name)
    if entity.components[name] == nil then
        return nil
    end

    if type(entity.components[name]) == "function" then
        return entity.components[name]()
    end
    return entity.components[name]
end

function ecs.setComponentData(entity, name, data)
    entity.components[name] = data
end

function ecs.removeComponentData(entity, name)
    entity.components[name] = nil
end

function ecs.getEntitiesByType(type)
    local entities = {}
    for _, entity in ipairs(ecs.entities) do
        if entity.type == type then
            table.insert(entities, entity)
        end
    end
    return entities
end

function ecs.getEntitiesByComponent(name)
    local entities = {}
    for _, entity in ipairs(ecs.entities) do
        if entity.components[name] ~= nil then
            table.insert(entities, entity)
        end
    end
    return entities
end

function ecs.getEntitiesByComponents(components)
    local entities = {}
    for _, entity in ipairs(ecs.entities) do
        local hasComponents = true
        for _, component in ipairs(components) do
            if entity.components[component] == nil then
                hasComponents = false
                break
            end
        end
        if hasComponents then
            table.insert(entities, entity)
        end
    end
    return entities
end

--Systems

function ecs.createSystem(name, components, callback, type)
    local system = {
        name = name,
        components = components,
        callback = callback,
        type = type
    }
    table.insert(ecs.systems, system)
end

function ecs.attachSystemsToEntityTypes(entityTypes)
    for _, entityType in ipairs(entityTypes) do
        for _, system in ipairs(ecs.systems) do
            if system.type == entityType then
                table.insert(system.entities, entityType)
            end
        end
    end
end

function ecs.ensureEntityTypesHaveSystem(entityTypes, systemName)
    for _, entityType in ipairs(entityTypes) do
        local hasSystem = false
        for _, system in ipairs(ecs.systems) do
            if system.name == systemName and system.type == entityType then
                hasSystem = true
                break
            end
        end
        if not hasSystem then
            ecs.createSystem(systemName, {}, function() end, entityType)
        end
    end
end

function ecs.getSystem(name)
    for _, system in ipairs(ecs.systems) do
        if system.name == name then
            return system
        end
    end
    return nil
end

function ecs.removeSystem(name)
    for i, system in ipairs(ecs.systems) do
        if system.name == name then
            table.remove(ecs.systems, i)
            break
        end
    end
end

function ecs.getSystemsByComponent(name)
    local systems = {}
    for _, system in ipairs(ecs.systems) do
        for _, component in ipairs(system.components) do
            if component == name then
                table.insert(systems, system)
                break
            end
        end
    end
    return systems
end

function ecs.getSystemsByComponents(components)
    local systems = {}
    for _, system in ipairs(ecs.systems) do
        local hasComponents = true
        for _, component in ipairs(components) do
            local hasComponent = false
            for _, systemComponent in ipairs(system.components) do
                if component == systemComponent then
                    hasComponent = true
                    break
                end
            end
            if not hasComponent then
                hasComponents = false
                break
            end
        end
        if hasComponents then
            table.insert(systems, system)
        end
    end
    return systems
end

function ecs.updateSystem(name, dt)
    for _, system in ipairs(ecs.systems) do
        if system.name == name then
            system.callback(dt)
        end
    end
end

function ecs.drawSystem(name, params)
    for _, system in ipairs(ecs.systems) do
        if system.name == name then
            system.callback(params)
        end
    end
end

function ecs.drawSystemByEntityType(name, type)
    for _, entity in ipairs(ecs.entities) do
        if entity.type == type then
            ecs.drawSystem(name, entity)
        end
    end
end

function ecs.drawSystemsForAllEntities()
    for _, entity in ipairs(ecs.entities) do
        local systems = ecs.getSystemsByEntity(entity)

        for _, system in ipairs(systems) do
            if system.type == "render" then
                system.callback(entity)
            end
        end
    end
end

function ecs.updateSystemsForAllEntities(dt)
    for _, entity in ipairs(ecs.entities) do
        local systems = ecs.getSystemsByEntity(entity)

        for _, system in ipairs(systems) do
            if system.type == "update" then -- Ensure only render systems are executed
                system.callback(entity)
            end
        end
    end
end

function ecs.getSystemsByEntity(entity)
    local systems = {}
    for _, system in ipairs(ecs.systems) do
        local hasComponents = true
        for _, component in ipairs(system.components) do
            if entity.components[component] == nil then
                hasComponents = false
                break
            end
        end
        if hasComponents then
            table.insert(systems, system)
        end
    end
    return systems
end

function ecs.update(dt)
    ecs.updateSystemsForAllEntities(dt)
end

function ecs.draw()
    ecs.drawSystemsForAllEntities()
end

return ecs
