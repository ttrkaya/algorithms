#include <iostream>
#include <vector>

size_t binarySearch(std::vector<int>& a, int x){
  size_t lo = 0;
  size_t hi = a.size();
  while(lo < hi){
    size_t mid = (lo + hi) / 2;
    if(a[mid] < x){
      lo = mid + 1;
    }
    else{
      hi = mid;
    }
  }
  return lo;
}


int main(){
  std::vector<int> a{1, 3, 6, 6, 7};

  for(int i = 0; i < 10; i++){
    std::cout << i << " : " << binarySearch(a, i) << std::endl;
  }

  return 0;
}
