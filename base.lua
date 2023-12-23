function COLLISION_SQUARE_TRIANGLE(sq_x, sq_y, sq_side, tri_x1, tri_y1, tri_x2, tri_y2, tri_x3, tri_y3)
    --[[
    --- COLLISION_SQUARE_TRIANGLE function

    -- Checks for collision between a square and a triangle using the Separating Axis Theorem (SAT).
    -- The square is defined by its top-left corner (sq_x, sq_y), side length (sq_side), and the triangle
    -- is defined by its vertices (tri_x1, tri_y1), (tri_x2, tri_y2), and (tri_x3, tri_y3).

    
    * @param sq_x The x-coordinate of the top-left corner of the square.
    * @param sq_y The y-coordinate of the top-left corner of the square.
    * @param sq_side The side length of the square.
    * @param tri_x1 The x-coordinate of the first vertex of the triangle.
    * @param tri_y1 The y-coordinate of the first vertex of the triangle.
    * @param tri_x2 The x-coordinate of the second vertex of the triangle.
    * @param tri_y2 The y-coordinate of the second vertex of the triangle.
    * @param tri_x3 The x-coordinate of the third vertex of the triangle.
    * @param tri_y3 The y-coordinate of the third vertex of the triangle.
    * @return boolean True if collision is detected, false otherwise.
    --]]

    --[[
    --- Checks if a point is inside the square.
    * @local
    * @param px The x-coordinate of the point.
    * @param py The y-coordinate of the point.
    * @return boolean True if the point is inside the square, false otherwise.
    --]]
    local function point_inside_square(px, py)
        return px >= sq_x and px <= sq_x + sq_side and py >= sq_y and py <= sq_y + sq_side
    end

    --[[
    --- Checks if two line segments intersect.
    * @local
    * @param ax The x-coordinate of the first endpoint of the first segment.
    * @param ay The y-coordinate of the first endpoint of the first segment.
    * @param bx The x-coordinate of the second endpoint of the first segment.
    * @param by The y-coordinate of the second endpoint of the first segment.
    * @param cx The x-coordinate of the first endpoint of the second segment.
    * @param cy The y-coordinate of the first endpoint of the second segment.
    * @param dx The x-coordinate of the second endpoint of the second segment.
    * @param dy The y-coordinate of the second endpoint of the second segment.
    * @return boolean True if the segments intersect, false otherwise.

    --]]
    local function segments_intersect(ax, ay, bx, by, cx, cy, dx, dy)
        local orientation1 = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)
        local orientation2 = (bx - ax) * (dy - ay) - (by - ay) * (dx - ax)
        local orientation3 = (dx - cx) * (ay - cy) - (dy - cy) * (ax - cx)
        local orientation4 = (dx - cx) * (by - cy) - (dy - cy) * (bx - cx)

        return (orientation1 * orientation2 < 0) and (orientation3 * orientation4 < 0)
    end

    -- Check if any vertex of the triangle is inside the square
    if point_inside_square(tri_x1, tri_y1) or point_inside_square(tri_x2, tri_y2) or point_inside_square(tri_x3, tri_y3) then
        return true
    end

    local square_x2 = sq_x + sq_side
    local square_y2 = sq_y + sq_side

    -- Check for intersection between square edges and triangle edges
    if segments_intersect(sq_x, sq_y, square_x2, sq_y, tri_x1, tri_y1, tri_x2, tri_y2) or
       segments_intersect(square_x2, sq_y, square_x2, square_y2, tri_x1, tri_y1, tri_x2, tri_y2) or
       segments_intersect(square_x2, square_y2, sq_x, square_y2, tri_x1, tri_y1, tri_x2, tri_y2) or
       segments_intersect(sq_x, square_y2, sq_x, sq_y, tri_x1, tri_y1, tri_x2, tri_y2) then
        return true
    end

    if segments_intersect(sq_x, sq_y, square_x2, sq_y, tri_x2, tri_y2, tri_x3, tri_y3) or
       segments_intersect(square_x2, sq_y, square_x2, square_y2, tri_x2, tri_y2, tri_x3, tri_y3) or
       segments_intersect(square_x2, square_y2, sq_x, square_y2, tri_x2, tri_y2, tri_x3, tri_y3) or
       segments_intersect(sq_x, square_y2, sq_x, sq_y, tri_x2, tri_y2, tri_x3, tri_y3) then
        return true
    end

    if segments_intersect(sq_x, sq_y, square_x2, sq_y, tri_x1, tri_y1, tri_x3, tri_y3) or
       segments_intersect(square_x2, sq_y, square_x2, square_y2, tri_x1, tri_y1, tri_x3, tri_y3) or
       segments_intersect(square_x2, square_y2, sq_x, square_y2, tri_x1, tri_y1, tri_x3, tri_y3) or
       segments_intersect(sq_x, square_y2, sq_x, sq_y, tri_x1, tri_y1, tri_x3, tri_y3) then
        return true
    end

    return false
end
