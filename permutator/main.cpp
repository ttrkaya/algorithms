#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

const int MAX_COMB = 33;
int comb[MAX_COMB + 1][MAX_COMB + 1];

const int MAX_PERM = 12;
int perm[MAX_PERM + 1];

void initComb()
{
	comb[0][0] = 1;
	for (int y = 1; y <= MAX_COMB; y++)
	{
		comb[y][0] = 1;
		comb[y][y] = 1;
		for (int x = 1; x < y; x++)
		{
			comb[y][x] = comb[y - 1][x - 1] + comb[y - 1][x];
		}
	}
}

void initPerm()
{
	perm[0] = 1;
	perm[1] = 1;
	for (int i = 2; i <= MAX_PERM; i++)
	{
		perm[i] = perm[i - 1] * i;
	}
}

int getOrder(vector<int> v)
{
	int tot = 0;
	for (int i = 0, s = (int)v.size(); i < s; i++)
	{
		int added = v[i] - i;
		tot += added * perm[v.size() - i - 1];
		for (int j = i; j < s; j++)
		{
			if (v[j] < v[i])
				 v[j]++;
		}
	}
	return tot;
}

vector<int> getPerm(int order, int size)
{
	vector<int> v;
	v.resize(size);
	vector<bool> gotten(size);
	for (int i = 0; i < size; i++)
	{
		int p = perm[size - i - 1];
		int added = order / p;
		order %= p;

		int to = 0;
		while (true)
		{
			if (!gotten[to])
			{
				if (added == 0) break;
				added--;
			}
			to++;
		}
		v[i] = to;
		gotten[to] = true;
	}
	return v;
}

int main()
{
	initComb();
	initPerm();

	const int vsize = 12; 
	vector<int> v;
	v.resize(vsize);
	for (int i = 0; i < vsize; i++)
	{
		v[i] = i;
	}

	for (int i = 0; i < perm[vsize]; i++)
	{
		int smartNum = getOrder(v);
		if (smartNum != i)
		{
			cout << ":(";
		}

		vector<int> smartPerm = getPerm(i, vsize);
		for (int j = 0; j < vsize; j++)
		{
			if (smartPerm[j] != v[j])
			{
				cout << ":'(";
				break;
			}
		}

		next_permutation(v.begin(), v.end());
	}

	cout << "fin" << endl;
	getchar();
	return 0;
}