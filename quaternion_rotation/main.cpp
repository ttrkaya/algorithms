#include <iostream>
#include <iomanip>

#include "Vec3.h"
#include "Quaternion.h"

const double PI = 3.14159265359;

using std::cin;
using std::cout;
using std::endl;

int main()
{
	cout << std::fixed << std::setprecision(3);

	const char seperatorString[] = "-------------";
	const char commaString[] = " , ";

	Vec3 a{ 5, 5, 5 };
	Vec3 b{ 1, 2, 3 };
	Vec3 c = a - b;

	cout << "a: " << a.x << commaString << a.y << commaString << a.z << endl;
	cout << "b: " << b.x << commaString << b.y << commaString << b.z << endl;
	cout << "a - b: " << c.x << commaString << c.y << commaString << c.z << endl;
	cout << seperatorString << endl;

	b.normalize();
	cout << "normalized b: " << b.x << commaString << b.y << commaString << b.z << endl;
	Vec3 zero;
	zero.normalize();
	cout << "normalized zero-vector: " << zero.x << commaString << zero.y << commaString << zero.z << endl;
	cout << seperatorString << endl;

	a = Vec3(1, 0, 0);
	b = Vec3(0, 1, 0);
	cout << "a: " << a.x << commaString << a.y << commaString << a.z << endl;
	cout << "b: " << b.x << commaString << b.y << commaString << b.z << endl;
	cout << "a * b: " << a * b << endl;
	c = a % b;
	cout << "a x b: " << c.x << commaString << c.y << commaString << c.z << endl;
	cout << seperatorString << endl;

	Vec3 x{ 1, 0, 0 };
	Vec3 y{ 0, 1, 0 };
	Vec3 z{ 0, 0, 1 };
	Quaternion q(Vec3(1, 0, 0), PI / 2);
	cout << "x: " << x.x << commaString << x.y << commaString << x.z << endl;
	cout << "q: " << q.r << commaString << q.v.x << commaString << q.v.y << commaString << q.v.z << endl;
	Quaternion rx = q * Quaternion(0, x) * ~q;
	cout << "rotated x: " << rx.r << commaString << rx.v.x << commaString << rx.v.y << commaString << rx.v.z << endl;
	Quaternion ry = q * Quaternion(0, y) * ~q;
	cout << "rotated y: " << ry.r << commaString << ry.v.x << commaString << ry.v.y << commaString << ry.v.z << endl;
	Quaternion rz = q * Quaternion(0, z) * ~q;
	cout << "rotated z: " << rz.r << commaString << rz.v.x << commaString << rz.v.y << commaString << rz.v.z << endl;
	cout << seperatorString << endl;

	Quaternion q2(Vec3(0, 1, 0), PI / 2);
	cout << "q2: " << q2.r << commaString << q2.v.x << commaString << q2.v.y << commaString << q2.v.z << endl;
	Quaternion qc = q2 * q;
	cout << "combined: " << qc.r << commaString << qc.v.x << commaString << qc.v.y << commaString << qc.v.z << endl; 
	Vec3 rvx = qc.rotate(x);
	cout << "rotated x: " << rvx.x << commaString << rvx.y << commaString << rvx.z << endl;
	Vec3 rvy = qc.rotate(y);
	cout << "rotated y: " << rvy.x << commaString << rvy.y << commaString << rvy.z << endl;
	Vec3 rvz = qc.rotate(z);
	cout << "rotated z: " << rvz.x << commaString << rvz.y << commaString << rvz.z << endl;
	cout << seperatorString << endl;
	

	getchar();
	return 0;
}