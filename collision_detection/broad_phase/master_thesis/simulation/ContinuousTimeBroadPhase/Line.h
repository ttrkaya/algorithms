#pragma once

#include "Constants.h"
#include "Vec2.h"

class Line
{
public:
	Vec2 a, b;
	Line() {}
	Line(Vec2 a_, Vec2 b_) : a(a_), b(b_) {}
	Line(real ax, real ay, real bx, real by) : a(ax, ay), b(bx, by) {}
};

