#include "..\..\script_macros.hpp"
/*
    File: fn_civInteractionMenu.sqf
    Author: Matt "codeYeTi" Coffin

    Description:
    Replaces the mass addactions for various civ actions towards another player.
*/
#define BTN(N) (37450 + N)
#define Title 37401

private ["_target", "_display", "_buttonIdx", "_fnc_setupButton"];

disableSerialization;
_target = param [0, objNull, [objNull]];

if (player distance _target > 4) exitWith { closeDialog 0; };

if (!dialog) then {
    createDialog "pInteraction_Menu";
};

_display = findDisplay 37400;

life_pInact_curTarget = _target;

_fnc_setupButton = {
    params ["_button", "_locToken", "_action"];
    _button ctrlSetText localize _locToken;
    _button buttonSetAction _action;
};

[
    _display displayCtrl BTN(1),
    "STR_pInAct_GiveKey",
    "closeDialog 0; createDialog ""Chop_Shop""; [] call life_fnc_handKey;"
] call _fnc_setupButton;

for "_buttonIdx" from 2 to 8 do {
    (_display displayCtrl BTN(_buttonIdx)) ctrlShow false;
};
