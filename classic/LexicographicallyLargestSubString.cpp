// Find the lexicographically largest substring in a given string
// The result will always be a suffix
// O(n) time
// O(1) space
// by ttrkaya
// 7 jun 2025

#include <string>
#include <algorithm>
#include <iostream>
#include <cstdlib>
#include <cassert>

using namespace std;

int twoPointers(const string& s){
  int n = s.length();
  int res = 0;
  for(int cand = 1, len = 0; cand + len < n; len = 0){
    while(cand + len < n && s[cand + len] == s[res + len]) len++;
    if(cand + len < n && s[res + len] < s[cand + len]){
      int resOld = res;
      res = cand;
      cand = max(cand + 1, resOld + len + 1);
    } else{
      cand += len + 1;
    }
  }
  return res;
}

// O(n^2)
int naive(const string& s){
  int n = s.length();
  int res = 0;
  for(int cand = 1; cand < n; cand++){
    for(int len = 0; cand + len < n; len++){
      if(s[res + len] == s[cand + len]) continue;
      if(s[res + len] < s[cand + len]) res = cand;
      break;
    }
  }
  return res;
}

void test(const string& s){
  cout << s << ": ";
  int start = twoPointers(s);
  cout << s.substr(start) << endl;
  int check = naive(s);
  assert(start == check);
}

int main(){
  test("aabb");
  {
    string s;
    for(int i = 0; i < 99; i++) s.push_back('a');
    s.push_back('b');
    test(s);
  }
  for(int t = 0; t < 999999; t++){
    string s;
    int n = rand() % 99;
    for(int i = 0; i < n; i++){
      s.push_back('a' + (rand() % 26));
    }
    test(s);
  }
  return 0;
}
