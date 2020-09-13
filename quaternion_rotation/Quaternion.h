#pragma once

#include <cmath>

#include "Vec3.h"

class Quaternion
{
public:

	double r;
	Vec3 v;

	Quaternion(double r_, Vec3 v_) : r(r_), v(v_) {}
	Quaternion(double r_ = 0, double i = 0, double j = 0, double k = 0) : r(r_), v(i, j, k) {}
	Quaternion(const Vec3& axis, double angle);

	void negate() { v *= -1.0; }
	void normalize() { double l = std::sqrt(r*r + v.lengthSquared()); r /= l; v /= l; }

	Quaternion operator*(const Quaternion& q) const;
	Quaternion operator~() const {return Quaternion(r, v * -1.0); }

	Vec3 rotate(const Vec3& v) const;
};

