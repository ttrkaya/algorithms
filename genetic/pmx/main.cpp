// Partially Mapped Crossover Algorithm
// Takes 2 permutations, creates a random child permutation via genetic cross over
//
// https://www.researchgate.net/publication/226665831_Genetic_Algorithms_for_the_Travelling_Salesman_Problem_A_Review_of_Representations_and_Operators
//
// by ttrkaya
// 2015

const int N = 10;
int p1[] = { 8, 4, 7, 3, 6, 2, 5, 1, 9, 0 };
int p2[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
int c[N];

int main()
{
	int p2inv[N];
	int cinv[N];
	for (int i = 0; i < N; i++)
	{
		p2inv[p2[i]] = i;

		c[i] = -1;
		cinv[i] = -1;
	}

	int cutStart = 3;
	int cutEnd = 8;

	for (int i = cutStart; i < cutEnd; i++)
	{
		c[i] = p1[i];
		cinv[c[i]] = i;
	}

	for (int i = cutStart; i < cutEnd; i++)
	{
		if (cinv[p2[i]] >= 0) continue;
	
		int v = p2[i];
		int to = p2inv[p1[i]];

		while (c[to] >= 0)
		{
			to = p2inv[p1[to]];
		}

		c[to] = v;
		cinv[v] = to;
	}

	for (int i = 0; i < N; i++)
	{
		if (c[i] < 0)
		{
			c[i] = p2[i];
		}
	}

	return 0;
}