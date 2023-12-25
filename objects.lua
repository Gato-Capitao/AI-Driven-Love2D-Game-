--[[
This script has the objects and factories of the project.
]]--
math.randomseed(os.time())--Configuration to make the function math.random work correctly

CONSTRUCTOR_BUDDY = {} --The constructor that will create the buddy

function CONSTRUCTOR_BUDDY:create(x, y, pmod_distance, pmod_top, pmod_down, p_trigger)
    --[[
    This function returns a table representing a buddy with specific properties and functions.

    @param x: The horizontal position where the buddy should be created (number).
    @param y: The vertical position where the buddy should be created (number).
    @param pmod_distance: The distance modifier (neural system value) of its father (number).
    @param pmod_top: The top modifier (modifier of top obstacle's stub position) of its father (number).
    @param pmod_down: The bottom modifier (modifier of bottom obstacle's stub position) of its father (number).
    @p_trigger: The trigger (value deciding if the buddy will act or not) of its father (number).

    The function initializes a buddy with random variations and default values.

    The buddy object has the following properties:
    - x: Horizontal position.
    - y: Vertical position.
    - velocity: Buddy's jumping velocity.
    - width: Buddy's width.
    - mod_distance: Distance modifier.
    - mod_top: Top modifier.
    - mod_down: Bottom modifier.
    - trigger: Trigger value.
    - points: Buddy's points.
    - active: Flag indicating if the buddy is active.

    The buddy object also has the following methods:
    - jump(): Makes the buddy jump.
    - destroy(lost_points): Destroys the buddy, updating points and setting it as inactive.

    @return: The initialized buddy object.
    ]]
    -- Concrete creator
    local buddy = {
        x = x,
        y = y,
        velocity = 10,
        width = 50,
        mod_distance = pmod_distance + math.random(0, 100) / 100,
        mod_top = pmod_top + math.random(-100, 100) / 100,
        mod_down = pmod_down + math.random(-100, 100) / 100,
        trigger = p_trigger + math.random(-100, 100) / 100,
        points = 0,
        active = true,
    }
    setmetatable(buddy, self)
    self.__index = self

    function buddy:jump()
        buddy.y = buddy.y - buddy.velocity
    end

    function buddy:destroy(lost_points)
        -- Hide the body
        buddy.points = buddy.points - lost_points
        buddy.x = 0 - buddy.width
        buddy.active = false
    end

    return buddy
end


CONSTRUCTOR_OBSTACLES = {} --The constructor that will create the obstacle

function CONSTRUCTOR_OBSTACLES:create(x, isTop, max_length, total_length)
    --[[
    This function creates and returns an obstacle object based on the provided parameters.

    @param x: The horizontal position where the obstacle should be created (number).
    @param isTop: A boolean flag indicating whether the obstacle should be positioned at the top (boolean).
    @param max_length: The maximum length of the obstacle stub (number).
    @param total_length: The total length of the play area (number).

    The function initializes an obstacle with the following properties:
    - x: Horizontal position.
    - stub: The length of the obstacle stub.
    - vertices: Table representing the vertices of the obstacle polygon.

    If isTop is true, the obstacle is positioned at the top of the play area; otherwise, it is positioned at the bottom.

    The obstacle object has the following properties:
    - x: Horizontal position.
    - stub: Length of the obstacle stub.
    - vertices: Table representing the vertices of the obstacle polygon.

    @return: The initialized obstacle object.
    ]]--
    local y
    local obstacle = {}

    if isTop then
        y = 0
        obstacle.stub = math.random(max_length)
    else
        y = total_length
        obstacle.stub = total_length - max_length
    end

    obstacle.vertices = {x, obstacle.stub, x - 20, y, x + 20, y}

    return obstacle
end
