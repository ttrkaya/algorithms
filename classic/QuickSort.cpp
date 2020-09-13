#include <iostream>
#include <algorithm>
#include <random>

using namespace std;

const int MAX_N = 10000;

int quickSorted[MAX_N];
int algoSorted[MAX_N];

void quickSort(int l, int r) // left and right limits, inclusive
{
	if (l >= r) return;

	int pivotAt = l;
	int pivotVal = quickSorted[pivotAt];

	int till = r;
	for (int i = l + 1; i <= till; i++)
	{
		if (quickSorted[i] <= pivotVal)
		{
			quickSorted[pivotAt] = quickSorted[i];
			pivotAt = i;
		}
		else
		{
			swap(quickSorted[i], quickSorted[till]);
			till--;
			i--;
		}
	}
	quickSorted[pivotAt] = pivotVal;

	quickSort(l, pivotAt - 1);
	quickSort(pivotAt + 1, r);
}

int main()
{
	for (int testNo = 0; testNo < 1000000; testNo++)
	{
		int length = rand() % MAX_N + 1;
		for (int i = 0; i < length; i++)
		{
			quickSorted[i] = algoSorted[i] = rand();
		}

		sort(algoSorted, algoSorted + length);
		quickSort(0, length - 1);

		for (int i = 0; i < length; i++)
		{
			if (quickSorted[i] != algoSorted[i])
			{
				cout << "failed at: " << testNo << endl;
			}
		}
		if (testNo % 1000 == 0) cout << testNo << endl;
	}
	cout << "finished" << endl;
	return 0;
}