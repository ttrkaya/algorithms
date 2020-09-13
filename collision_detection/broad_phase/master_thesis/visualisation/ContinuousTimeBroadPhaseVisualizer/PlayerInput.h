#pragma once

#include <SDL.h>

class PlayerInput
{
public:
	static bool w;
	static bool a;
	static bool s;
	static bool d;

	static bool right;
	static bool left;
	static bool up;
	static bool down;

	static bool x;
	static bool z;
	static bool space;
	static bool enter;

	static bool r;
	static bool esc;

	static void handleKey(SDL_Keycode keyCode, bool isDown);
};

