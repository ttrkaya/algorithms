#include "Quaternion.h"

Quaternion::Quaternion(const Vec3& axis, double angle)
{
	angle /= 2;
	r = std::cos(angle);
	double s = std::sin(angle);
	v = axis * s;
}

Quaternion Quaternion::operator*(const Quaternion& q) const
{
	return Quaternion(r * q.r - v * q.v, v * q.r + q.v * r + v % q.v);
}

Vec3 Quaternion::rotate(const Vec3& v) const
{
	Quaternion qr = *this * Quaternion(0, v) * ~(*this);
	return qr.v;
}