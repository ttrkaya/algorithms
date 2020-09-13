#include "Circle.h"

bool Circle::doesCollide(const Circle& c) const
{
	real tr = r + c.r;
	real dx = pos.x - c.pos.x;
	real dy = pos.y - c.pos.y;
	return dx * dx + dy * dy <= tr * tr;
}

real Circle::getColTime(const Circle& o) const
{
	Vec2 dp = pos - o.pos;
	Vec2 dv = vel - o.vel;
	real d = dp * dv;
	if (d >= 0) return -1;

	real tr = r + o.r;

	real a = dv.magSqrd();
	if (a == 0) return -1;
	real b = 2 * d;
	real c = dp.magSqrd() - tr * tr;

	real det = b * b - 4 * a * c;
	real t = -(b + sqrt(det)) / (2 * a);
	return t;
}

real Circle::getColTime(const Line& l) const
{
	Vec2 ldir = l.b - l.a;
	ldir.normalize();

	Vec2 normal0 (ldir.y, -ldir.x);
	Vec2 normal1 (-ldir.y, ldir.x);
	real res0 = getColTimeWithLineNormal(l, normal0);
	real res1 = getColTimeWithLineNormal(l, normal1);

	if (res0 < 0) return res1;
	if (res1 < 0) return res0;
	return res0 < res1 ? res0 : res1;
}

real Circle::getColTimeWithLineNormal(const Line& l, const Vec2& normal) const
{
	if (vel * normal >= 0) return -1;

	//treat circle as an infinite ray starting from the circleTip towards vel
	Vec2 circleTip = pos - normal * r;
	
	Vec2 ldir = l.b - l.a;
	real dirCross = vel % ldir;
	if (dirCross == 0) return -1;

	Vec2 da = l.a - circleTip;
	real t = (da % ldir) / dirCross;
	real u = (da % vel) / dirCross;

	if (0 <= u && u <= 1) return t;
	return -1;
}

void Circle::collide(Circle& c)
{
	real tr = r + c.r;
	real sin = (c.pos.x - pos.x) / tr;
	real cos = (c.pos.y - pos.y) / tr;

	//rotated velocities
	Vec2 w0{vel.x * cos - vel.y * sin, vel.x * sin + vel.y * cos};
	Vec2 w1{c.vel.x * cos - c.vel.y * sin, c.vel.x * sin + c.vel.y * cos};

	//mass ratios
	real m0 = r * r;
	real m1 = c.r * c.r;
	real tm = m0 + m1;
	real m0ratio = m0 / tm;
	real m1ratio = m1 / tm;

	//collided rotated velocities
	Vec2 wa0{w0.x, (m0ratio - m1ratio) * w0.y + 2 * m1ratio * w1.y};
	Vec2 wa1{w1.x, (m1ratio - m0ratio) * w1.y + 2 * m0ratio * w0.y};

	//collided velocities
	vel.x = wa0.x * cos + wa0.y * sin;
	vel.y = -wa0.x * sin + wa0.y * cos;
	c.vel.x = wa1.x * cos + wa1.y * sin;
	c.vel.y = -wa1.x * sin + wa1.y * cos;
}

void Circle::collide(const Line& l)
{
	Vec2 ldir = l.b - l.a;
	Vec2 da = pos - l.a;
	Vec2 normal (ldir.y, ldir.x);
	normal.normalize();
	if (ldir % da < 0)
	{
		normal.x *= -1;
	}
	else
	{
		normal.y *= -1;
	}

	Vec2 bounceVel = normal * (normal * vel);
	vel -= bounceVel * 2;
}