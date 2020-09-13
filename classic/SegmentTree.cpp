#include <iostream>
#include <vector>
#include <assert.h>
#include <random>
#include <ctime>

#define MIN(x, y) ((x) < (y) ? (x) : (y))
#define MAX(x, y) ((x) > (y) ? (x) : (y))

using namespace std;

const int BIG = 2000000000;

class SegmentTree // for min
{
private:
	vector<int> arr;
public:
	SegmentTree(const vector<int>& data)
	{
		int dataSize = (int)data.size();
		int dataSizeUp = 1;
		while (dataSizeUp < dataSize)
		{
			dataSizeUp *= 2;
		}

		int arrSize = dataSizeUp * 2 - 1;
		arr.resize(arrSize);
		for (int i = 0; i < dataSize; i++)
		{
			arr[i + dataSizeUp - 1] = data[i];
		}
		for (int i = dataSize; i < dataSizeUp; i++)
		{
			arr[i + dataSizeUp - 1] = BIG;
		}

		for (int i = dataSizeUp - 2; i >= 0; i--)
		{
			arr[i] = MIN(arr[i * 2 + 1], arr[i * 2 + 2]);
		}
	}

	int getMinBetween(int start, int end) // inclusive [start, .. , end]
	{
		return getMinBetween(start, end, 0, 0, arr.size() / 2);
	}

	void update(int index, int value)
	{
		int at = arr.size() / 2 + index;
		arr[at] = value;
		updateUp((at - 1) / 2);
	}

private:
	int getMinBetween(int qs, int qe, int at, int ns, int ne) // all inclusive
	{
		if (ns == qs && ne == qe) return arr[at];
	
		int r = BIG;
		int middle = (ns + ne) / 2;
		if (qs <= middle)
		{
			int qe0 = MIN(qe, middle);
			int r0 = getMinBetween(qs, qe0, at * 2 + 1, ns, middle);
			if (r0 < r)
			{
				r = r0;
			}
		}
		if (qe > middle)
		{
			int qs1 = MAX(qs, middle + 1);
			int r1 = getMinBetween(qs1, qe, at * 2 + 2, middle + 1, ne);
			if (r1 < r)
			{
				r = r1;
			}
		}
		return r;
	}

	void update(int index, int value, int at, int ns, int ne)
	{
		if (ns == ne)
		{
			arr[at] = value;
			updateUp((at - 1) / 2);
			return;
		}

		int middle = (ns + ne) / 2;
		if (index <= middle)
		{
			update(index, value, at * 2 + 1, ns, middle);
		}
		else
		{
			update(index, value, at * 2 + 2, middle + 1, ne);
		}
	}

	void updateUp(int at)
	{
		int newMin = MIN(arr[at * 2 + 1], arr[at * 2 + 2]);
		if (newMin != arr[at])
		{
			arr[at] = newMin;
			if (at > 0)
			{
				updateUp((at - 1) / 2);
			}
		}
	}
};

int brute(const vector<int>& data, int qs, int qe)
{
	int r = BIG;
	for (int i = qs; i <= qe; i++)
	{
		if (data[i] < r)
		{
			r = data[i];
		}
	}
	return r;
}

int main()
{
	srand((unsigned int)time((time_t)0));

	const int DATA_SIZE = rand() + 100;
	vector<int> data;
	data.resize(DATA_SIZE);
	for (int i = 0; i < DATA_SIZE; i++)
	{
		data[i] = rand();
	}

	SegmentTree st(data);

	for (int i = 0; i < BIG; i++)
	{
		int qs = rand() % DATA_SIZE;
		int qe = qs + (rand() % (DATA_SIZE - qs));

		int dumb = brute(data, qs, qe);
		int smart = st.getMinBetween(qs, qe);

		if (smart != dumb)
		{
			cout << ":("; // insert break-point
		}

		int ci = rand() % DATA_SIZE;
		int cv = rand();
		st.update(ci, cv);
		data[ci] = cv;
	}

	cout << "fin" << endl;

	getchar();
	return 0;
	
}