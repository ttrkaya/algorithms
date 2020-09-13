#pragma once

#include "Constants.h"
#include "Vec2.h"
#include "Line.h"

class Circle
{
public:
	Vec2 pos, vel;
	real r;
	Circle() {}
	Circle(real x_, real y_, real r_, real vx_ = 0, real vy_ = 0) : pos(x_, y_), r(r_), vel(vx_, vy_) {}

	real getColTime(const Circle& c) const;
	real getColTime(const Line& l) const;
	void collide(Circle& c);
	void collide(const Line& l);

	bool doesCollide(const Circle& c) const;

private:
	real getColTimeWithLineNormal(const Line& l, const Vec2& normal) const;
};

