#include "script_component.hpp"
// Rotate tank to face enemy
// version 1.41
// by nkenny

/*
    Design:
        Find a spot to turn towards
        End script when Tank reasonably turned
        Inspiration by the work of alarm9k @ https://forums.bohemia.net/forums/topic/172270-smarter-tanks-script/

    Arguments:
        0, vehicle which will do the movement     [Object]
        1, Direction which we wish to end up     [Array] (Default -- nearest enemy)
        2, acceptable threshold                 [Number] (Default : 18 degrees)

    Other:
        Also thanks to Natalie.
*/

// init
params ["_unit",["_target", []],["_threshold",18]];

if (_targets isEqualTo []) then {
    _target = _unit findNearestEnemy _unit;
};

// cannot move or moving
if (!canMove _unit || {currentCommand _unit isEqualTo "MOVE"}) exitWith {true};

// CQB tweak <-- disabled! more dynamic vehicles is better!!
if (_unit distance _target < GVAR(CQB_range)) exitWith {true};

_unit setVariable [QGVAR(currentTarget), _target];
_unit setVariable [QGVAR(currentTask), "Vehicle Rotate"];

// within acceptble limits -- suppress instead
if (_unit getRelDir _target < _threshold || {_unit getRelDir _target > (360-_threshold)}) exitWith {
    [_unit,(_target call bis_fnc_position)] call FUNC(vehicleSuppress);
    true
};

// settings
private _pos = [];
private _min = 20;      // Minimum range
private _i = 0;         // iterations

while {count _pos < 1} do {
    _pos = (_unit getPos [_min,_unit getDir _target]) findEmptyPosition [0, 2.2, typeOf _unit];

    // water
    if (count _pos > 0) then {if (surfaceIsWater _pos) then {_pos = []};};

    // update
    _min = _min + 15;
    _i = _i + 1;
    if (_i > 6) exitWith {_pos = _unit modelToWorldVisual [0,-100,0]};
};

// move
_unit doMove _pos;

// delay
_time = time + (4 + random 6);
waitUntil {sleep 0.1;(_unit getRelDir _target < _threshold || {_unit getRelDir _target > (360-_threshold)}) || {time > _time}};

// check vehicle
if (!canMove _unit || {count crew _unit < 1}) exitWith {false};

// refresh ready (For HC apparently)
effectiveCommander _unit doMove getPosASL _unit;

// refresh formation
group _unit setFormDir (_unit getDir _target);

// end
true
