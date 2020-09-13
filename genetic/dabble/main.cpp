#include <iostream>
#include <random>
#include <vector>

#include "Node.h"

const int MAX_DEPTH = 4;
const int SIZE = 100;
const int DIRECT_PASSERS = 5;
const int NUM_GENERATIONS = 10000;

double targetFunction(double x) // x^2 - 2x + 5
{
	return 5 + x * ( -2 + x);
}

double normalizedRand(double max)
{
	return (double(rand()) / RAND_MAX) * max;
}

int main()
{
	srand(0);

	Node bestFit;
	double minError = DBL_MAX;

	std::vector<Node> population(SIZE);
	std::vector<double> errors(SIZE);
	std::vector<double> cumProbs(SIZE + 1);
	cumProbs[0] = 0.0;
	for (unsigned int i = 0; i < population.size(); i++)
	{
		population[i].generate(MAX_DEPTH);
	}

	for (int g = 0; g < NUM_GENERATIONS; g++)
	{
		for (int i = 0; i < SIZE; i++)
		{
			errors[i] = 0.0;
			for (double x = -9.9; x < 10; x += 0.1)
			{
				errors[i] += std::abs(targetFunction(x) - population[i].evaluate(x));
			}
			if (errors[i] < minError)
			{
				minError = errors[i];
				bestFit = population[i];
			}
			if (minError == 0.0) break;

			cumProbs[i + 1] = cumProbs[i] + (1.0 / errors[i]);
		}
		if (minError == 0.0) break;

		std::vector<Node> newGen;
		
		for (int i = 0; i < DIRECT_PASSERS; i++)
		{
			double r = normalizedRand(cumProbs[SIZE]);
			int directPasserIndex = 0;
			while (cumProbs[directPasserIndex + 1] < r) directPasserIndex++;
			newGen.push_back(population[directPasserIndex]);

			newGen.push_back(newGen.back());
			newGen.back().mutate();
		}

		while (newGen.size() < SIZE)
		{
			double r = normalizedRand(cumProbs[SIZE]);
			int p0 = 0;
			while (cumProbs[p0 + 1] < r) p0++;
			r = normalizedRand(cumProbs[SIZE]);
			int p1 = 0;
			while (cumProbs[p1 + 1] < r) p1++;

			Node child;
			child.setAsChildOf(population[p0], population[p1]);
			if (child.getDepth() <= MAX_DEPTH) newGen.push_back(child);
		}

		population.clear();
		population = newGen;
	}

	std::cout << "Error: " << minError << std::endl;
	std::cout << bestFit.getString() << std::endl;
	getchar();

	return 0;
}