CONSTRUCTOR_BUDDY = {}
math.randomseed(os.time())

function  CONSTRUCTOR_BUDDY:create(x, y, pmod_distance, pmod_top, pmod_down, p_trigger)
    --Concrete creator 
    local buddy = {
        x = x, 
        y = y, 
        velocity = 10, 
        width = 50, 
        mod_distance = pmod_distance + math.random(0, 100)/100,
        mod_top = pmod_top + math.random(-100, 100)/100,
        mod_down = pmod_down + math.random(-100, 100)/100,
        trigger = p_trigger + math.random(-100, 100)/100,
        points = 0,
        active = true,
    }
    setmetatable(buddy, self) 
    self.__index = self
    

    function buddy:jump()
        buddy.y = buddy.y - buddy.velocity
    end

    function buddy:destroy(lost_points)
        --hide the body
        buddy.points = buddy.points - lost_points
        buddy.x = 0-buddy.width
        buddy.active = false
    end

    return buddy
end

CONSTRUCTOR_OBSTACLES = {}

function  CONSTRUCTOR_OBSTACLES:create(x, isTop, max_lenght, total_lenght)
    local y
    local obstacle = {
    }

    if isTop then
        y = 0
        obstacle.stub = math.random(max_lenght)
    else
        y = total_lenght
        obstacle.stub = total_lenght-max_lenght
    end

    obstacle.vertices = {x, obstacle.stub, x-20, y, x+20, y}

    return obstacle
end
