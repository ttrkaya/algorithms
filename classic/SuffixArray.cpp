// Suffix array algorithm
// initialization: O(n*(logn)^2)
// find: O(m*logn)
// by ttrkaya
// 01 oct 2015

#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

namespace suffixArray{

using namespace std;

//helper struct for sorting pairs
struct T{
	int a, b, i;
	T() : a(0), b(0), i(0) {}
	bool operator<(const T& o) const{
		if (a != o.a) return a < o.a;
		if (b != o.b) return b < o.b;
		return false;
	}
	bool operator==(const T& o) const{ return a == o.a && b == o.b; }
	bool operator!=(const T& o) const{ return a != o.a || b != o.b; }
};

//suffix array matrix
//last line is the suffix array
vector<vector<int>> m;
//init suffix array
void initm(const string& s){
	int n = s.length();
	vector<T> v(n);
	for (int i = 0; i < n; i++){
		v[i].a = s[i];
		v[i].i = i;
	}
	sort(v.begin(), v.end());
	m.push_back(vector<int>(n));
	m.back()[v[0].i] = 0;
	int at = 0;
	for (int i = 1; i < n; i++){
		if (v[i - 1] != v[i]) at++;
		m.back()[v[i].i] = at;
	}
	for (int k = 1; k < n; k *= 2){
		for (int i = 0; i < n - k; i++){
			v[i].a = m.back()[i];
			v[i].b = m.back()[i + k];
			v[i].i = i;
		}
		for (int i = n - k; i < n; i++){
			v[i].a = m.back()[i];
			v[i].b = -1;
			v[i].i = i;
		}
		sort(v.begin(), v.end());
		m.push_back(vector<int>(n));
		m.back()[v[0].i] = 0;
		at = 0;
		for (int i = 1; i < n; i++){
			if (v[i - 1] != v[i]) at++;
			m.back()[v[i].i] = at;
		}
	}
}

vector<string> sortSuffixes(const string& s){
	initm(s);
	vector<string> res(s.length());
	for (int i = 0; i < s.length(); i++){
		res[m.back()[i]] = s.substr(i);
	}
	return res;
}

void test(){
	const string t = "banana";
	auto v = sortSuffixes(t);
	cout << "Sorted suffixes of: " << t << endl;
	for (const string& s : v){
		cout << s << endl;
	}
}

}

int mainSuf(){
	using namespace suffixArray;

	test();

	return 0;
}