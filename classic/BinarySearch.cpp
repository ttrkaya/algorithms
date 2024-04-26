#include <vector>

int binarySearch(std::vector<int>& a, int x){
  int s = 0;
  int e = (int)a.size();
  while(s < e){
    int m = (s + e) / 2;
    if(x < a[m]){
      e = m;
    }
    else{
      s = m + 1;
    }
  }
  return s;
}
