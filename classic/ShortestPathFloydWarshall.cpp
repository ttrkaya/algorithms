// Floyd-Warshall algorithm for finding the minimum distance between all pairs
// Checks for every possible intermediate vertex to make the distance shorter
// O(n^3)
// by ttrkaya
// 02 oct 2015

#include <iostream>
#include <vector>
#include <algorithm>

namespace warshall{

using namespace std;

const int MAX_VAL = 999999999;

const int MAX_N = 1000;
int n;
int dists[MAX_N][MAX_N];

void calcAllPairDistances(){
	for (int k = 0; k < n; k++){ // intermediate
		for (int i = 0; i < n; i++){ // from
			for (int j = 0; j < n; j++){ // to
				dists[i][j] = min(dists[i][j], dists[i][k] + dists[k][j]);
			}
		}
	}
}

void test(int testId){
	cout << "Test #" << testId << ":" << endl;
	calcAllPairDistances();
	for (int y = 0; y < n; y++){
		for (int x = 0; x < n; x++){
			if (dists[y][x] == MAX_VAL) cout << "-";
			else cout << dists[y][x];
			cout << '\t';
		}
		cout << endl;
	}
}

void initDists(){ // as if no edges
	for (int y = 0; y < n; y++) for (int x = 0; x < n; x++) dists[y][x] = MAX_VAL;
	for (int i = 0; i < n; i++) dists[i][i] = 0;
}

}

int mainWarsh(){
	using namespace warshall;

	int curTestId = 1;

	n = 2;
	initDists();
	dists[0][1] = dists[1][0] = 3;
	test(curTestId++);

	n = 3;
	initDists();
	dists[0][1] = dists[1][0] = 1;
	dists[1][2] = dists[2][1] = 2;
	test(curTestId++);

	n = 3;
	initDists();
	dists[0][1] = dists[1][0] = 1;
	dists[1][2] = dists[2][1] = 2;
	dists[0][2] = dists[2][0] = 5;
	test(curTestId++);

	n = 3;
	initDists();
	dists[0][1] = dists[1][0] = 1;
	dists[1][2] = dists[2][1] = 2;
	dists[0][2] = dists[2][0] = 2;
	test(curTestId++);

	n = 5;
	initDists();
	dists[0][1] = dists[1][0] = 1;
	dists[1][2] = dists[2][1] = 2;
	dists[2][3] = dists[3][2] = 3;
	dists[3][4] = dists[4][3] = 4;
	dists[0][4] = dists[4][0] = 11;
	test(curTestId++);

	n = 5;
	initDists();
	dists[0][1] = dists[1][0] = 1;
	dists[1][2] = dists[2][1] = 2;
	dists[2][3] = dists[3][2] = 3;
	test(curTestId++);


	return 0;
}