#include <iostream>

using namespace std;

const int N = 5;
int x[N] {2,3,10,7,100};
int y[N] {2,3,11,6,101};

int main()
{
	int totx = 0;
	int totx2 = 0;
	int toty = 0;
	int totxy = 0;
	for (int i = 0; i < N; i++)
	{
		int xx = x[i];
		int yy = y[i];
		totx += xx;
		totx2 += xx * xx;
		toty += yy;
		totxy += xx * yy;
	}

	double det = totx2 * N - totx * totx;
	double m11 = N / det;
	double m22 = totx2 / det;
	double m12 = -totx / det;
	double m21 = m12;

	double b = m11 * totxy + m12 * toty;
	double a = m21 * totxy + m22 * toty;

	cout << "y = " << b << "x + " << a << endl;
	getchar();
	return 0;
}