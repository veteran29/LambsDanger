#include "script_component.hpp"
// DEBUG : return danger type
// version 1.01
// by nkenny

// init
params ["_select"];

// return
if (_select isEqualTo -1) exitWith {"No Danger"};
if (_select isEqualTo 0) exitWith {"Enemy Detected"};
if (_select isEqualTo 1) exitWith {"Fire"};
if (_select isEqualTo 2) exitWith {"Hit"};
if (_select isEqualTo 3) exitWith {"Enemy Near"};
if (_select isEqualTo 4) exitWith {"Explosion"};
if (_select isEqualTo 5) exitWith {"Dead Body from my group"};
if (_select isEqualTo 6) exitWith {"Dead Body"};
if (_select isEqualTo 7) exitWith {"Scream heard"};
if (_select isEqualTo 8) exitWith {"Can Fire"};
if (_select isEqualTo 9) exitWith {"Bullet close!"};
"UNKNOWN"
