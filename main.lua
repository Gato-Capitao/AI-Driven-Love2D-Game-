require("objects")
require("base")
math.randomseed(os.time())

local gravity = -5
local SCREEN_WIDTH = love.graphics.getWidth()
local SCREEN_HEIGHT = love.graphics.getHeight()
local QNT_PER_GENERATION = 500
local current_qnt
local current_generation = 0
local obstacles_velocity = 5


buddies = {}
obstacles = {
    top = {},
    down = {}
}

function create_obstacles()
    table.insert(obstacles.top,constructor_obstacle:create(SCREEN_WIDTH, true, SCREEN_HEIGHT/1.5, SCREEN_HEIGHT))

    local tamanho = #obstacles.top
    local max_height = SCREEN_HEIGHT-(obstacles.top[tamanho].stub+150)
    table.insert(obstacles.down, constructor_obstacle:create(SCREEN_WIDTH, false, max_height, SCREEN_HEIGHT))
end

function get_best()
    local max_points = 0
    local best
    
    for _, buddy in pairs(buddies) do
        if buddy.points>max_points then
            max_points = buddy.points
            best = buddy
        end
    end

    return best
end

function generate_buddies()
    local initial_x = 50
    local initial_y = 100
    local sum = 0
    local mod_distance = 0.5
    local mod_down = 0.5
    local mod_top = 0.5
    local trigger = 500

    if current_generation>0 then
        --Reborn the best buddy
        best_buddy = get_best()
            --Reset points
        best_buddy.points = 0
        best_buddy.active = true
        best_buddy.x = initial_x
        best_buddy.y = initial_y
            --Clear the table
        buddies = {}
        table.insert(buddies, best_buddy)
        sum = sum+1

        mod_distance = best_buddy.mod_distance
        mod_down = best_buddy.mod_down
        mod_top = best_buddy.mod_top
        trigger = best_buddy.trigger
    else
        buddies = {}
    end
    
    for index = 1+sum, QNT_PER_GENERATION do
        table.insert(buddies, constructor_buddy:create(initial_x, initial_y, mod_distance, mod_top, mod_down, trigger))
    end

    current_qnt = QNT_PER_GENERATION
    current_generation = current_generation + 1

    print(mod_distance, mod_down, mod_top, trigger)
    return buddies
end

function love.load()
    --Initialize
    buddies = generate_buddies()

    --Create obstacles
    obstacles.top = {}
    obstacles.down = {}

    create_obstacles()
end

function love.draw()
    --Create buddies
    for _, buddy in pairs(buddies) do
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle("line", buddy.x, buddy.y, buddy.width, buddy.width)
    end

    --Create obstacles
    love.graphics.setColor(1, 0, 0)
    for index = 1, #obstacles.top do
        love.graphics.polygon("line", obstacles.top[index].vertices)
        love.graphics.polygon("line", obstacles.down[index].vertices)
    end
    
end

function love.update()
    local first_obstacle_top = obstacles.top[1].vertices
    local first_obstacle_down = obstacles.down[1].vertices

    for pos, buddy in pairs(buddies) do
        if buddy.active == true then
            --Give points
            buddy.points = -1*(obstacles.top[1].vertices[1]-buddy.x)+math.abs(obstacles.top[1].stub-buddy.y)+math.abs(obstacles.down[1].stub-buddy.y)
            --Move buddy
            buddy.y = buddy.y - gravity
            trigger_on = buddy.mod_distance*(obstacles.top[1].vertices[1]-buddy.x)+buddy.mod_top*(obstacles.top[1].stub-buddy.y)+buddy.mod_down*(obstacles.down[1].stub-buddy.y)<=buddy.trigger

            keyboard_on = love.keyboard.isDown("space")
            if trigger_on or keyboard_on then
                buddy.jump()
            end

            --Verify if the buddy colide with a obstacle
            local colide_top_triangle = collision_square_triangle(buddy.x, buddy.y, buddy.width, first_obstacle_top[1], first_obstacle_top[2], first_obstacle_top[3], first_obstacle_top[4], first_obstacle_top[5], first_obstacle_top[6])
            local colide_down_triangle = collision_square_triangle(buddy.x, buddy.y, buddy.width, first_obstacle_down[1], first_obstacle_down[2], first_obstacle_down[3], first_obstacle_down[4], first_obstacle_down[5], first_obstacle_down[6])
            local colide_border = buddy.y < 0 or buddy.y+buddy.width > SCREEN_HEIGHT
            
            if colide_top_triangle or colide_down_triangle then
                buddy:destroy(1)
                current_qnt = current_qnt - 1
            elseif colide_border then
                buddy:destroy(100)
                current_qnt = current_qnt - 1
            end

        end 
    end

    --Verify if there is any buddy
    if current_qnt==0 then
        love.load()
        return 0
    end

    --Move obstacles
    for index=1, #obstacles.top do
        for index_vertice = 1, 6 do
            if index_vertice%2==1 then
                obstacles.top[index].vertices[index_vertice] = obstacles.top[index].vertices[index_vertice] - obstacles_velocity
                obstacles.down[index].vertices[index_vertice] = obstacles.down[index].vertices[index_vertice] - obstacles_velocity
            end
        end
    end

    --Create more obstacles
    if obstacles.top[#obstacles.top].vertices[1] < 300 then
        create_obstacles()
    end

    --Remove obstacles if hits the border
    if obstacles.top[1].vertices[1] <= 0 then
        table.remove(obstacles.top, 1)
        table.remove(obstacles.down, 1)
    end
end
