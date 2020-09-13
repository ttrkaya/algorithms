// A raycasting algorithm to test if a point lies inside polyon
// by ttrkaya
// 01 oct 2015

#include <iostream>
#include <vector>

namespace pointInPolygon{

using namespace std;

struct P{
	double x, y;
	P(){}
	P(double x_, double y_) : x(x_), y(y_) {}
};

bool isPointInPolygon(const P& o, const vector<P>& poly){
	bool res = false;
	P from = poly.back();
	for (const P& to : poly){
		if ((from.y <= o.y && o.y < to.y || to.y <= o.y && o.y < from.y) &&
			o.x < from.x + (to.x - from.x) * (o.y - from.y) / (to.y - from.y)){
			res = !res;
		}
		from = to;
	}
	return res;
}

void test(int testId, P o, vector<P> poly){
	cout << "Test #" << testId << ": " << (isPointInPolygon(o, poly) ? "IN" : "OUT") << endl;
}

}

int mainPointInPoly(){
	using namespace pointInPolygon;

	int curTestId = 1;

	test(curTestId++, P(1, 1), vector<P>{
		P(0, 0),
		P(0, 5),
		P(5, 0)
	});

	test(curTestId++, P(4, 4), vector<P>{
		P(0, 0),
		P(0, 5),
		P(5, 0)
	});

	test(curTestId++, P(3, 3), vector<P>{
		P(0, 0),
		P(0, 5),
		P(5, 5),
		P(5, 0)
	});

	test(curTestId++, P(6, 3), vector<P>{
		P(0, 0),
		P(0, 5),
		P(5, 5),
		P(5, 0)
	});

	test(curTestId++, P(3, 6), vector<P>{
		P(0, 0),
		P(0, 5),
		P(5, 5),
		P(5, 0)
	});

	test(curTestId++, P(3, 3), vector<P>{
		P(0, 0),
		P(0, 3),
		P(0, 5),
		P(5, 5),
		P(5, 0)
	});

	test(curTestId++, P(3, 3), vector<P>{
		P(0, 0),
		P(0, 5),
		P(3, 5),
		P(5, 5),
		P(5, 0)
	});

	test(curTestId++, P(3, 3), vector<P>{
		P(0, 0),
		P(0, 5),
		P(3, 5),
		P(5, 5),
		P(5, 0)
	});

	test(curTestId++, P(1, 3), vector<P>{
		P(0, 0),
		P(3, 3),
		P(5, 0),
		P(5, 5),
		P(0, 5)
	});

	test(curTestId++, P(9, 3), vector<P>{
		P(0, 0),
		P(3, 3),
		P(5, 0),
		P(5, 5),
		P(0, 5)
	});

	return 0;
}