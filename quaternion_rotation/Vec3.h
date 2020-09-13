#pragma once

#include <cmath>

class Vec3
{
public:

	double x, y, z;

	Vec3(double x_ = 0, double y_ = 0, double z_ = 0): x(x_), y(y_), z(z_) {}

	Vec3 operator+(const Vec3& v) const { return Vec3(x + v.x, y + v.y, z + v.z); }
	Vec3 operator-(const Vec3& v) const { return Vec3(x - v.x, y - v.y, z - v.z); }

	void operator+=(const Vec3& v) { x += v.x; y += v.y; z += v.z; }
	void operator-=(const Vec3& v) { x -= v.x; y -= v.y; z -= v.z; }

	Vec3 operator*(double s) const { return Vec3(x * s, y * s, z * s); }
	Vec3 operator/(double s) const { return Vec3(x / s, y / s, z / s); }

	void operator*=(double s) { x *= s; y *= s; z *= s; }
	void operator/=(double s) { x /= s; y /= s; z /= s; }

	double operator*(const Vec3& v) const { return x * v.x + y * v.y + z * v.z; }
	Vec3 operator%(const Vec3& v) const{ return Vec3(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x); }

	double lengthSquared() const { return x * x + y * y + z * z; }
	double length() const { return std::sqrt(lengthSquared()); }
	void normalize() { double l = length(); if (l > 0.0) this->operator/=(l); }
};

