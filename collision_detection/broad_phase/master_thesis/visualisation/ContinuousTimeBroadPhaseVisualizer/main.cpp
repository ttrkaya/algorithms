#include <string>

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>
#include <SDL_mixer.h>

#include "Constants.h"
#include "PlayerInput.h"
#include "Model.h"
#include "Renderer.h"

real getNow()
{
	return SDL_GetTicks() / 1000.0;
}

int main(int argc, char** argv)
{
	Model* model = new Model();
	model->init("simvis.txt");
	model->progress(0);

	SDL_Init(SDL_INIT_EVERYTHING);
	IMG_Init(IMG_INIT_PNG);
	TTF_Init();
	Mix_Init(MIX_INIT_MP3);

	SDL_Window* window = SDL_CreateWindow("Empty", 50, 50, Constants::WIN_W, Constants::WIN_H, SDL_WINDOW_SHOWN);
	SDL_Renderer* context = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

	Renderer* renderer = new Renderer();
	renderer->initialize(context);
	renderer->render(*model, 0, 0);

	real lastUpdateTime = getNow();
	bool quit = false;
	bool started = false;
	real speed = 1.0;
	int aabbstart = 0;
	SDL_Event event;
	while (!quit)
	{
		real now = getNow();
		real dt = now - lastUpdateTime;
		lastUpdateTime = now;

		while (SDL_PollEvent(&event))
		{
			if (event.type == SDL_QUIT)
			{
				quit = true;
			}
			else if (event.type == SDL_KEYDOWN)
			{
				PlayerInput::handleKey(event.key.keysym.sym, true);
			}
			else if (event.type == SDL_KEYUP)
			{
				PlayerInput::handleKey(event.key.keysym.sym, false);
			}
		}
		if (PlayerInput::esc) quit = true;

		if (PlayerInput::space)
		{
			PlayerInput::space = false;
			if (!started)
			{
				started = true;
			}
			else
			{
				model->reset();
				started = false;
			}
		}

		if (PlayerInput::right)
		{
			PlayerInput::right = false;
			speed *= 2;
			cout << "Speed: " << speed << endl;
		}
		if (PlayerInput::left)
		{
			PlayerInput::left = false;
			speed *= 0.5;
			cout << "Speed: " << speed << endl;
		}

		if (started && !model->finished())
		{
			model->progress(dt * speed);
		}

		if (PlayerInput::up)
		{
			PlayerInput::up = false;
			aabbstart /= 2;
			cout << "AABB level: " << aabbstart << endl;
		}
		if (PlayerInput::down)
		{
			PlayerInput::down = false;
			aabbstart *= 2;
			if (aabbstart == 0) aabbstart = 1;
			cout << "AABB level: " << aabbstart << endl;
		}

		renderer->render(*model, aabbstart, aabbstart * 2);
	}

	Mix_CloseAudio();
	Mix_Quit();
	TTF_Quit();
	IMG_Quit();
	SDL_Quit();

	return 0;
}