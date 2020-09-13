// Inversion counting algorithm with divide-and-conquer
// Runs in O(nlogn)
// An inversion is a pair of indices, i and j; where i < j and a[i] > a[j]
// by ttrkaya
// 12 nov 2015

#include <iostream>
#include <vector>

namespace invcount{
	using namespace std;

	typedef pair<int, int> ii;

	vector<ii> merge(vector<ii> a){
		int n = a.size();
		if (n == 1) return a;

		auto mid = a.begin() + n / 2;
		vector<ii> l = merge(vector<ii>{a.begin(), mid});
		vector<ii> r = merge(vector<ii>{mid, a.end()});

		vector<ii> res;
		res.reserve(n);
		int c = 0;
		int i = (int)l.size() - 1;
		int j = (int)r.size() - 1;
		while (i >= 0 && j >= 0){
			if (l[i].first > r[j].first){
				c++;
				res.push_back(l[i--]);
			}
			else{
				r[j].second += c;
				res.push_back(r[j--]);
			}
		}
		while (i >= 0){
			res.push_back(l[i--]);
		}
		while (j >= 0){
			r[j].second += c;
			res.push_back(r[j--]);
		}
		reverse(res.begin(), res.end());
		return res;
	}

	int getinversionCount(const vector<int>& a){
		int n = a.size();
		vector<ii> toConquer;
		for (int i = 0; i < n; i++) toConquer.push_back(ii(a[i], 0));
		vector<ii> conqured = merge(toConquer);
		int res = 0;
		for (ii i : conqured) res += i.second;
		return res;
	}
}

int mainInvCount(){
	using namespace invcount;

	vector<int> a;

	a = vector<int> {1};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {1, 2};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {2, 1};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {1, 2, 3};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {2, 1, 3};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {1, 3, 2};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {2, 3, 1};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {3, 2, 1};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {1, 2, 3, 4};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {4, 1, 2, 3};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {4, 1, 3, 2};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {4, 3, 2, 1};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {1, 2, 3, 4, 5};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {5, 4, 3, 2, 1};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	a = vector<int> {9, 8, 7, 6, 5, 4, 3, 2, 1};
	for (int x : a) cout << x << " ";
	cout << "=> " << getinversionCount(a) << endl;

	return 0;
}