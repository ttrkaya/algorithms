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

namespace sized {
vector<int> parent;
vector<int> size;
void init(int n) {
	parent.resize(n);
	size.resize(n);
  for (int i = 0; i < n; i++) {
    parent[i] = i;
    size[i] = 1;
  }
}
int find(int x) {
  int root = x;
  while (parent[root] != root) root = parent[root];
  int at = x;
  while (parent[at] != root) {
    int to = parent[at];
    parent[at] = root;
    at = to;
  }
  return root;
}
void join(int x, int y) {
  int rootX = find(x);
  int rootY = find(y);
  if (rootX != rootY) {
    if (size[rootX] < size[rootY]) {
      parent[rootX] = rootY;
      size[rootY] += size[rootX];
    } else {
      parent[rootY] = rootX;
      size[rootX] += size[rootY];
    }
  }
}

void test(int testId, int x, int y) {
  cout << "Test #" << testId << ": " << (find(x) == find(y) ? "IN" : "OUT") << endl;
}
}  // namespace sized
}  // namespace dsu

int main() {
  using namespace dsu;

  int testId;
  int n;

	cout << "Simple:" << endl;
	testId = 1;
  n = 2;
  simple::init(n);
  simple::test(testId++, 0, 1);

  n = 2;
  simple::init(n);
  simple::join(0, 1);
  simple::test(testId++, 0, 1);

  n = 3;
  simple::init(n);
  simple::join(0, 1);
  simple::join(1, 2);
  simple::test(testId++, 0, 2);

  n = 4;
  simple::init(n);
  simple::join(0, 1);
  simple::join(2, 3);
  simple::test(testId++, 0, 3);

  n = 1000;
  simple::init(n);
  for (int i = 0; i < n / 2; i++) simple::join(i, i + 1);
  for (int i = n / 2 + 1; i < n - 1; i++) simple::join(i, i + 1);
  simple::test(testId++, n / 2, n / 2 + 1);

  n = 1000;
  simple::init(n);
  for (int i = 0; i < n / 2; i++) simple::join(i, i + 1);
  for (int i = n / 2 + 1; i < n - 1; i++) simple::join(i, i + 1);
  simple::join(n / 2, n / 2 + 1);
  simple::test(testId++, 0, n - 1);

	cout << "Sized:" << endl;
	testId = 1;
  n = 2;
  sized::init(n);
  sized::test(testId++, 0, 1);

  n = 2;
  sized::init(n);
  sized::join(0, 1);
  sized::test(testId++, 0, 1);

  n = 3;
  sized::init(n);
  sized::join(0, 1);
  sized::join(1, 2);
  sized::test(testId++, 0, 2);

  n = 4;
  sized::init(n);
  sized::join(0, 1);
  sized::join(2, 3);
  sized::test(testId++, 0, 3);

  n = 1000;
  sized::init(n);
  for (int i = 0; i < n / 2; i++) sized::join(i, i + 1);
  for (int i = n / 2 + 1; i < n - 1; i++) sized::join(i, i + 1);
  sized::test(testId++, n / 2, n / 2 + 1);

  n = 1000;
  sized::init(n);
  for (int i = 0; i < n / 2; i++) sized::join(i, i + 1);
  for (int i = n / 2 + 1; i < n - 1; i++) sized::join(i, i + 1);
  sized::join(n / 2, n / 2 + 1);
  sized::test(testId++, 0, n - 1);

  return 0;
}