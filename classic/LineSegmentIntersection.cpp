// 2D line segment intersection
// Parallel lines are considered non-intersecting even if overlapping
// by ttrkaya
// 02 oct 2015

#include <iostream>

namespace lines{

using namespace std;

typedef double real;

struct Vec{
	real x, y;
	Vec() {}
	Vec(real x_, real y_) : x(x_), y(y_) {}
	Vec operator-(const Vec& v) const { return Vec(x - v.x, y - v.y); }
	real operator%(const Vec& v) const { return x * v.y - y * v.x; }
	real operator*(const Vec& v) const { return x * v.x + y * v.y; }
};

struct Line{
	Vec a, b;
	Line(){}
	Line(Vec a_, Vec b_) : a(a_), b(b_) {}
	Line(real ax, real ay, real bx, real by) : a(ax, ay), b(bx, by) {}
};

bool doIntersect(const Line& l1, const Line& l2){
	Vec d1 = l1.b - l1.a;
	if (((l2.a - l1.a) % d1) * ((l2.b - l1.a) % d1) >= 0) return false;
	Vec d2 = l2.b - l2.a;
	if (((l1.a - l2.a) % d2) * ((l1.b - l2.a) % d2) >= 0) return false;
	return true;
}

// assumes intersection
Vec getIntersectionPoint(const Line& l1, const Line& l2){
	Vec d1 = l1.b - l1.a;
	Vec d2 = l2.b - l2.a;
	real t = ((l2.a - l1.a) % d2) / (d1 % d2);
	return Vec(l1.a.x + t * d1.x, l1.a.y + t * d1.y);
}

void test(int testId, Line l1, Line l2){
	cout << "Test #" << testId << ": ";
	if (doIntersect(l1, l2)){
		Vec p = getIntersectionPoint(l1, l2);
		cout << p.x << " : " << p.y;
	}
	else{
		cout << "NO INTERSECTION";
	}
	cout << endl;
}

}

int mainLines(){
	using namespace lines;

	int curTestId = 1;

	test(curTestId++, Line(0, 0, 5, 5), Line(0, 5, 5, 0));
	test(curTestId++, Line(0, 0, 5, 0), Line(1, 1, 5, 5));
	test(curTestId++, Line(0, 0, 5, 0), Line(0, 5, 5, 5));
	test(curTestId++, Line(0, 0, 0, 5), Line(5, 0, 5, 5));
	test(curTestId++, Line(0, 0, 1, 0), Line(5, -3, 5, 3));
	test(curTestId++, Line(0, 0, 10, 0), Line(5, 5, 5, 3));
	test(curTestId++, Line(0, 0, 10, 0), Line(5, 0, 15, 0));

	return 0;
}