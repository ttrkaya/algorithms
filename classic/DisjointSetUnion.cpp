// Disjoint set union algorithm for joining and testing whether two are in same set
// Beware of possible stack overflows, may need a large stack memory
// by ttrkaya
// 01 oct 2015
// update: 
// 06 oct 2025

#include <iostream>
#include <vector>

using namespace std;

namespace dsu {
namespace simple {
vector<int> parent;
void init(int n) {
  parent.resize(n);
  for (int i = 0; i < n; i++) parent[i] = i;
}
int find(int x) { return x == parent[x] ? x : parent[x] = find(parent[x]); }
void join(int x, int y) { parent[find(x)] = find(y); }

void test(int testId, int x, int y) {
  cout << "Test #" << testId << ": " << (find(x) == find(y) ? "IN" : "OUT") << endl;
}
}  // namespace simple
}  // namespace dsu

int main() {
  using namespace dsu;

  int curTestId = 1;
  int n;

  n = 2;
  simple::init(n);
  simple::test(curTestId++, 0, 1);

  n = 2;
  simple::init(n);
  simple::join(0, 1);
  simple::test(curTestId++, 0, 1);

  n = 3;
  simple::init(n);
  simple::join(0, 1);
  simple::join(1, 2);
  simple::test(curTestId++, 0, 2);

  n = 4;
  simple::init(n);
  simple::join(0, 1);
  simple::join(2, 3);
  simple::test(curTestId++, 0, 3);

  n = 1000;
  simple::init(n);
  for (int i = 0; i < n / 2; i++) simple::join(i, i + 1);
  for (int i = n / 2 + 1; i < n - 1; i++) simple::join(i, i + 1);
  simple::test(curTestId++, n / 2, n / 2 + 1);

  n = 1000;
  simple::init(n);
  for (int i = 0; i < n / 2; i++) simple::join(i, i + 1);
  for (int i = n / 2 + 1; i < n - 1; i++) simple::join(i, i + 1);
  simple::join(n / 2, n / 2 + 1);
  simple::test(curTestId++, 0, n - 1);

  return 0;
}