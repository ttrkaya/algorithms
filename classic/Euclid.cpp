// Euclid and extended Euclid algorithms
// by ttrkaya
// 05 oct 2015

#include <iostream>

namespace euclid{

using namespace std;

// euclidian algorithm to return the greatest common divisor in logaritmic time
int gcd(int a, int b){ return  b == 0 ? a : gcd(b, a % b); }
// returns the least common multiple
int lcm(int a, int b){ return a / gcd(a, b) * b; }

// extended euclidian algorithm to solve the equation:
// x * a + y * b = gcd(a, b)
void exgcd(int a, int b, int& x, int& y){
	if (b > 0){
		exgcd(b, a % b, y, x);
		y -= x * (a / b);
	}
	else{
		x = 1;
		y = 0;
	}
}

void test(int a, int b){
	int x, y;
	exgcd(a, b, x, y);
	cout << x << " * " << a << " + " << y << " * " << b << " = " << gcd(a, b) << endl;
}

}

int mainEuclid(){
	using namespace euclid;

	test(2, 3);
	test(3, 6);
	test(6, 9);
	test(9, 15);
	test(99, 100);
	test(42, 38);
	test(1, 3);
	test(3, 1);
	test(0, 3);
	test(3, 0);

	return 0;
}