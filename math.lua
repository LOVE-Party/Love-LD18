
function dist(x, y, ox, oy)
	x, y = x - (ox or 0), y - (oy or 0)
	return math.sqrt(x^2 + y^2)
end

function angletopoint(x, y, ox, oy)
	return math.atan2(y-(oy or 0), x-(ox or 0)) -- according to the docs, the parms are (y, x), not (x, y)
end

-- <ballcag> well, there are 2pi radians in a revolution
-- <ballcag> radians is basically an arclength to circumference ratio
-- <ballcag> so if you want degrees
-- <ballcag> multiply by 360 and divide by 2pi
-- <ballcag> also, it may return negative stuff, depending on its range
-- <ballcag> which doesn't mean error, just means backwards
-- <ballcag> if you want it to be strictly positive, you can modulo 2pi (or 360 if you have degrees)
--
-- you should probably use math.deg()
function radiantodegrees(rad)
	return (rad * 360) / (2 * math.pi)
end

-- <ballcag> Textmode: yes
-- <ballcag> lol
-- <Textmode> ballcag: care to explain why? :P
-- <ballcag> imagine a right triangle, pick an angle that is not the right angle
-- <ballcag> cos (angle) = adjacent leg / hypotenuse
-- <Textmode> hurt!
-- <ballcag> now hypotenuse is radius in ur case, so multiplying by hypotenuse gives you the adjacent leg
-- <Textmode> ah.
-- <Textmode> the side of the triangle, yes?
-- <ballcag> sin = opposite / hypotenuse
-- <ballcag> yep
-- <ballcag> so same deal there
-- <ballcag> now these functions are extended so that the positive and negative values make sense in between polar coordinate transformations
-- <Textmode> same with the opisate angle, giving use the other side, which are the two sides my ealrier triangle method started with, yes?
-- <ballcag> yeah
-- <Textmode> only with less typos.
function polartorect(r, t)
	return r * math.cos(t), r * math.sin(t)
end

