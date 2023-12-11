function collision_square_triangle(sq_x, sq_y, sq_side, tri_x1, tri_y1, tri_x2, tri_y2, tri_x3, tri_y3)
    local function point_inside_square(px, py)
        return px >= sq_x and px <= sq_x + sq_side and py >= sq_y and py <= sq_y + sq_side
    end

    local function segments_intersect(ax, ay, bx, by, cx, cy, dx, dy)
        local orientation1 = (bx - ax) * (cy - ay) - (by - ay) * (cx - ax)
        local orientation2 = (bx - ax) * (dy - ay) - (by - ay) * (dx - ax)
        local orientation3 = (dx - cx) * (ay - cy) - (dy - cy) * (ax - cx)
        local orientation4 = (dx - cx) * (by - cy) - (dy - cy) * (bx - cx)

        return (orientation1 * orientation2 < 0) and (orientation3 * orientation4 < 0)
    end

    if point_inside_square(tri_x1, tri_y1) or point_inside_square(tri_x2, tri_y2) or point_inside_square(tri_x3, tri_y3) then
        return true
    end

    local square_x2 = sq_x + sq_side
    local square_y2 = sq_y + sq_side

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