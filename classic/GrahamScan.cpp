// Graham Scan algorithm for producing the convex hull
// by ttrkaya
// 30 sept 2015

#include <iostream>
#include <vector>
#include <cmath>
#include <algorithm>

namespace graham{

using namespace std;
typedef double real;

struct P{
	double x, y, angle;
	P(){}
	P(double x_, double y_) : x(x_), y(y_) {}
	bool operator<(const P& o) const { return angle < o.angle; }
};

// test for counter-clockwise turn
bool ccw(const P& p1, const P& p2, const P& p3)
{
	return (p2.x - p1.x) * (p3.y - p1.y) < (p2.y - p1.y) * (p3.x - p1.x);
}

vector<P> getConvexHull(const vector<P>& points){
	int n = points.size();
	vector<P> hull = points;
	P lowest = hull.front();
	for (int i = 1; i < n; i++){
		if (hull[i].y < lowest.y){
			lowest = hull[i];
		}
	}
	for (int i = 0; i < n; i++){
		hull[i].angle = atan2(hull[i].y - lowest.y, hull[i].x - lowest.x);
	}
	sort(hull.begin(), hull.end());
	hull.push_back(hull.front());
	
	int m = 1;
	for (int i = 2; i <= n; i++){
		while (ccw(hull[m - 1], hull[m], hull[i])){
			if (m > 1) m--;
			else if (i == n) break;
			else i++;
		}
		m++;
		swap(hull[m], hull[i]);
	}
	hull.resize(m);
	return hull;
}


void test(int testId, vector<P> points){
	cout << "Test #" << testId << ":" << endl;
	for (P p : points) cout << p.x << "_" << p.y << "|";
	cout << endl;
	auto hull = getConvexHull(points);
	for (P p : hull) cout << p.x << "_" << p.y << "|";
	cout << endl;
}

}

int mainGraham(){
	using namespace graham;

	int curTestId = 1;

	test(curTestId++, vector<P>{
		P{ 0, 0 },
		P{ 1, 0 },
		P{ 0, 1 }
	});
	test(curTestId++, vector<P>{
		P{ 1, 1 },
		P{ 0, 0 },
		P{ 1, 0 },
		P{ 0, 1 }
	});
	test(curTestId++, vector<P>{
		P{ 0, 0 },
		P{ 2, 0 },
		P{ 0, 2 },
		P{ 2, 2 },
		P{ 1, 1 }
	});
	test(curTestId++, vector<P>{
		P{ 0, 0 },
		P{ 1, 1 },
		P{ 4, 0 },
		P{ 0, 4 },
		P{ 9, 9 },
		P{ 2, 1 },
		P{ 1, 2 },
	});
	return 0;
}