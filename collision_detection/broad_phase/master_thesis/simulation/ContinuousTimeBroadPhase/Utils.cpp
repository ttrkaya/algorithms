#include "Utils.h"


void Utils::init(int seed)
{
	srand(seed);
}


real Utils::getRandom()
{
	real r = rand();
	r /= RAND_MAX;
	return r;
}
