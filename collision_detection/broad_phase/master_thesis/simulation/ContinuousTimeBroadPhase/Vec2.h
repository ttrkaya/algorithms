#pragma once

#include <cmath>

#include "Constants.h"

class Vec2
{
public:
	real x, y;
	
	Vec2() {};
	Vec2(real x_, real y_) : x(x_), y(y_) {}

	void operator+=(const Vec2& v) { x += v.x; y += v.y; }
	void operator-=(const Vec2& v) { x -= v.x; y -= v.y; }
	void operator*=(real s) { x *= s; y *= s; }
	void operator/=(real s) { x /= s; y /= s; }
	Vec2 operator+(const Vec2& v) const { return Vec2(x + v.x, y + v.y); }
	Vec2 operator-(const Vec2& v) const { return Vec2(x - v.x, y - v.y); }
	Vec2 operator*(real s) const { return Vec2(x * s, y * s); }

	real operator*(const Vec2& v) const { return x * v.x + y * v.y; }
	real operator%(const Vec2& v) const { return x * v.y - y * v.x; }

	real magSqrd() const { return x * x + y * y; }
	real mag() const { return sqrt(magSqrd()); }
	void normalize() { real m = mag(); if(m > 0) *this /= m; }
	void zero() { x = y = 0; }
};

