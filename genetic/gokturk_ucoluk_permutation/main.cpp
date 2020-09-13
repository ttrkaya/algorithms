/*
ID: tupcuham1
PROG: twofive
LANG: C++11
*/
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <iomanip>
#include <string>
#include <vector>
#include <set>
#include <map>
#include <queue>
#include <deque>
#include <algorithm>
#include <cmath>
#include <climits>
#include <cfloat>

using namespace std;

int n;
vector<int> perm{3,7,5,1,4,0,2,6};
vector<int> inv; //5,3,4,0,2,1,1,0
vector<int> reperm;

void fillInv()
{
	for (int i = 0; i < n; i++) inv[i] = 0;

	for (int i = 0; i < n; i++)
	{
		for (int j = 0; perm[j] != i; j++)
		{
			if (perm[j] > i) inv[i]++;
		}
	}
}

void fillReperm()
{
	reperm.resize(n);
	vector<int> pos;
	pos.resize(n);

	for (int i = 0; i < n; i++) pos[i] = inv[i];

	for (int i = n - 1; i >= 0; i--)
	{
		for (int j = i + 1; j < n; j++)
		{
			if (pos[j] >= inv[i]) pos[j]++;
		}
	}

	for (int i = 0; i < n; i++) reperm[pos[i]] = i;
}

int main()
{
	n = perm.size();
	inv.resize(perm.size());

	fillInv();
	fillReperm();

	return 0;
}
