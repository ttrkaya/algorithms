// Manacher's algorithm
// Finds longest palindrome substring length at each index centered, including even length
// by ttrkaya
// 27 feb 2018

#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;

// puts unique char at ends and between all
string expand(string s){ 
	const char P = '#';
	string res;
	res.append(1, P);
	for(char c : s){
		res.append(1, c);
		res.append(1, P);
	}
	return res;
}

vector<int> manachers(string s){
	s = expand(s);
	int n = s.length();
	vector<int> res(n);

	int m = 0; // mirror center
	int r = 0; // mirror right bound
	for(int i = 0; i < n; i++){
		int& v = res[i];

		// start with the mirrored result
		if(i < r){
			int im = m - (i - m); // i mirrored
			v = min(res[im], r - i);
		}
		else{
			v = 0;
		}

		// expand one by one till end
		while(0 <= i - v - 1 && i + v + 1 < n && s[i - v - 1] == s[i + v + 1]) v++;

		// update mirror
		if(r < i + v){
			m = i;
			r = i + v;
		}
	}
	
	return res;
}

int main(){
	string s = "abaaba";
	auto res = manachers(s);
	for(int x : res) cout << x << " ";
	cout << endl;
	return 0;
}