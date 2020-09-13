#include <iostream>
#include <random>
#include <ctime>

const int M = 1000000;

int heap[M]; // implemented as array, not tree, for efficiency
int n; //number of elements in heap

void errr()
{
	//insert breakpoint
	heap[M - 1] = -1;
}

void check() // check for consistency of heap
{
	for (int i = 0; i < n; i++)
	{
		int c0 = 2 * i + 1;
		if (c0 < n && heap[c0] < heap[i]) errr();
		int c1 = 2 * i + 2;
		if (c1 < n && heap[c1] < heap[i]) errr();
	}
}

void ins(int x) // insert x to heap
{
	heap[n] = x;
	int c = n;
	n++;

	for (int p = (c - 1) / 2; p > 0 || c > 0; c = p, p = (c - 1) / 2)
	{
		if (heap[p] <= x) return;

		heap[c] = heap[p];
		heap[p] = x;
	}
}

int pop() // pop the minimum element
{
	int r = heap[0];
	int c = 0;
	while (true)
	{
		int c0 = 2 * c + 1;
		int c1 = 2 * c + 2;

		int cc = -1;
		if (c1 >= n)
		{
			if (c0 >= n)
			{
				break;
			}
			cc = c0;
		}
		else
		{
			cc = heap[c0] < heap[c1] ? c0 : c1;
		}
		heap[c] = heap[cc];
		c = cc;
	}
	n--;

	//put the last element into newly opened place
	int x = heap[n];
	heap[c] = x;
	for (int p = (c - 1) / 2; p > 0 || c > 0; c = p, p = (c - 1) / 2)
	{
		if (heap[p] <= x) break;

		heap[c] = heap[p];
		heap[p] = x;
	}

	return r;
}

void decrease(int i, int x) //decrease the element at i to value x
{
	heap[i] = x;
	int c = i;

	for (int p = (c - 1) / 2; p > 0 || c > 0; c = p, p = (c - 1) / 2)
	{
		if (heap[p] <= x) return;

		heap[c] = heap[p];
		heap[p] = x;
	}
}

int main()
{
	//randomized checks. fuck math, long live statistics
	std::srand(std::time(0));
	for (int i = 0; i < M; i++)
	{
		ins(std::rand());
		if (n > 1000 && std::rand() > RAND_MAX / 2) pop();
		if (n > 1000 && std::rand() > RAND_MAX / 2)
		{
			int at = std::rand() % n;
			int x = std::rand() % heap[at];
			decrease(at, x);
		}
		check();
	}

	return 0;
}