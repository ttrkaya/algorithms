// Some string matching algorithms: Naive, Rabin-Karp, FSM, KMP
// by ttrkaya
// 01 oct 2015

#include <iostream>
#include <string>
#include <vector>
#include <limits>
#include <random>

namespace stringMatching{

using namespace std;

const int NUM_CHARS = 256;
int rabinKarpPrime;

// naive O(n*m) check
vector<int> naive(const string& t, const string& p)
{
	vector<int> res;
	int n = t.length();
	int m = p.length();

	for (int i = 0; i <= n - m; i++)
	{
		int j = 0;
		while (j < m && t[i + j] == p[j]) j++;
		if (j == m)
		{
			res.push_back(i);
		}
	}
	return res;
}

bool isPrime(int x)
{
	for (int i = 2; i * i <= x; i++)
	{
		if (x % i == 0) return false;
	}
	return true;
}

void calculateRabinKarpPrime()
{
	rabinKarpPrime = INT_MAX / NUM_CHARS - NUM_CHARS;
	while (!isPrime(rabinKarpPrime)) rabinKarpPrime--;
}

bool exactTest(const string& t, const string& p, int at)
{
	int m = p.length();
	for (int i = 0; i < m; i++)
	{
		if (t[at + i] != p[i]) return false;
	}
	return true;
}

// hashed elimination
vector<int> rabinKarp(const string& t, const string& p)
{
	vector<int> res;
	int n = t.length();
	int m = p.length();

	if (n < m) return res;
	if (m == 0)
	{
		for (int i = 0; i <= n; i++) res.push_back(i);
		return res;
	}
	if (n == 0)
	{
		return res;
	}

	int key = p[0];
	int slider = t[0];
	int mostSignificantFactor = 1;
	for (int i = 1; i < m; i++)
	{
		key *= NUM_CHARS;
		key += p[i];
		key %= rabinKarpPrime;

		slider *= NUM_CHARS;
		slider += t[i];
		slider %= rabinKarpPrime;

		mostSignificantFactor *= NUM_CHARS;
		mostSignificantFactor %= rabinKarpPrime;
	}

	for (int i = 0; i < n - m; i++)
	{
		if (key == slider && exactTest(t, p, i))
		{
			res.push_back(i);
		}
		slider -= mostSignificantFactor * t[i];
		slider %= rabinKarpPrime;
		slider *= NUM_CHARS;
		slider += t[m + i];
		slider %= rabinKarpPrime;
		if (slider < 0) slider += rabinKarpPrime;
	}
	if (key == slider && exactTest(t, p, n - m))
	{
		res.push_back(n - m);
	}

	return res;
}

//building a finite state machine
vector<int> fsm(const string& t, const string& p)
{
	vector<int> res;
	int n = t.length();
	int m = p.length();

	vector<int> transition((m + 1) * NUM_CHARS);
	string upToNow;
	for (int state = 0; state <= m; state++)
	{
		if (state > 0) upToNow += p[state - 1];
		for (int i = 0; i < NUM_CHARS; i++)
		{
			unsigned char newChar = i;
			string newStr = upToNow + (char)i;
			int toState = (int)newStr.length();
			for (; toState > 0; toState--)
			{
				bool fits = true;
				for (int j = 0; j < toState; j++)
				{
					if (p[j] != newStr[newStr.length() - toState + j])
					{
						fits = false;
						break;
					}
				}
				if (fits) break;
			}
			transition[state * NUM_CHARS + newChar] = toState;
		}
	}

	int state = 0;
	for (int i = 0; i < n; i++)
	{
		if (state == m) res.push_back(i - m);
		state = transition[state * NUM_CHARS + (unsigned char)t[i]];
	}
	if (state == m) res.push_back(n - m);

	return res;
}

// Knuth–Morris–Pratt algorithm
vector<int> kmp(const string& t, const string& p)
{
	vector<int> res;

	int m = p.length();
	if (m == 0)
	{
		for (int i = 0; i <= (int)t.length(); i++) res.push_back(i);
		return res;
	}
	vector<int> lcp(m);
	lcp[0] = 0;
	int cur = 0;
	for (int i = 1; i < m; i++)
	{
		while (cur > 0 && p[cur] != p[i])
		{
			cur = lcp[cur - 1];
		}
		if (p[cur] == p[i])
		{
			cur++;
		}
		lcp[i] = cur;
	}

	int n = t.length();
	cur = 0;
	for (int i = 0; i < n; i++)
	{
		while (cur > 0 && p[cur] != t[i])
		{
			cur = lcp[cur - 1];
		}
		if (p[cur] == t[i])
		{
			cur++;
		}
		if (cur == m)
		{
			res.push_back(i + 1 - m);
			cur = lcp[m - 1];
		}
	}
	return res;
}

void init()
{
	srand(1);
	calculateRabinKarpPrime();
}

void randomizeString(string& s, int maxLenght)
{
	int l = rand() % maxLenght;
	s.resize(l);
	for (int i = 0; i < l; i++)
	{
		s[i] = 'a' + rand() % 26;
	}
}

bool areEqual(const vector<int> a, const vector<int> b)
{
	if (a.size() != b.size()) return false;

	for (int i = a.size() - 1; i >= 0; i--)
	{
		if (a[i] != b[i]) return false;
	}

	return true;
}

}

int mainStringMatch()
{
	using namespace stringMatching;

	init();

	const int MAX_LENGTH_T = 1000;
	const int MAX_LENGTH_P = 11;

	string t, p;
	for (int test = 0; test < 1000000000; test++)
	{
		randomizeString(p, MAX_LENGTH_P);
		randomizeString(t, MAX_LENGTH_T);
	
		vector<int> resultNaive = naive(t, p);

		vector<int> resultRabinKarp = rabinKarp(t, p);
		if (!areEqual(resultNaive, resultRabinKarp))
		{
			cout << ":( rabinKarp for p =" << endl << p  << "t =" << endl << t << endl;
		}

		vector<int> resultFsm = fsm(t, p);
		if (!areEqual(resultNaive, resultFsm))
		{
			cout << ":( fsm for p =" << endl << p << "t =" << endl << t << endl;
		}

		vector<int> resultKmp = kmp(t, p);
		if (!areEqual(resultNaive, resultKmp))
		{
			cout << ":( kmp for p =" << endl << p << "t =" << endl << t << endl;
		}

		if (test % 100 == 0){
			cout << "Num tests done:" << test << endl;
		}
	}

	cout << "fin" << endl;
	getchar();
	return 0;
}