#include "PlayerInput.h"

bool PlayerInput::w = false;
bool PlayerInput::a = false;
bool PlayerInput::s = false;
bool PlayerInput::d = false;
bool PlayerInput::left = false;
bool PlayerInput::right = false;
bool PlayerInput::up = false;
bool PlayerInput::down = false;
bool PlayerInput::x = false;
bool PlayerInput::z = false;
bool PlayerInput::space = false;
bool PlayerInput::enter = false;
bool PlayerInput::r = false;
bool PlayerInput::esc = false;

void PlayerInput::handleKey(SDL_Keycode keyCode, bool isDown)
{
	switch (keyCode)
	{
	case SDLK_w:
		PlayerInput::w = isDown;
		break;
	case SDLK_a:
		PlayerInput::a = isDown;
		break;
	case SDLK_s:
		PlayerInput::s = isDown;
		break;
	case SDLK_d:
		PlayerInput::d = isDown;
		break;
	case SDLK_LEFT:
		PlayerInput::left = isDown;
		break;
	case SDLK_RIGHT:
		PlayerInput::right = isDown;
		break;
	case SDLK_UP:
		PlayerInput::up = isDown;
		break;
	case SDLK_DOWN:
		PlayerInput::down = isDown;
		break;
	case SDLK_x:
		PlayerInput::x = isDown;
		break;
	case SDLK_y:
		PlayerInput::z = isDown;
		break;
	case SDLK_SPACE:
		PlayerInput::space = isDown;
		break;
	case SDLK_RETURN:
		PlayerInput::enter = isDown;
		break;
	case SDLK_r:
		PlayerInput::r = isDown;
		break;
	case SDLK_ESCAPE:
		PlayerInput::esc = isDown;
		break;
	}
}
