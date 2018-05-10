#include "..\..\script_macros.hpp"
private ["_disp", "_sellBtn", "_title", "_control", "_vehicle", "_uid", "_owners", "_target"];
_target = param [0, objNull, [objNull]];

if (life_action_inUse) exitWith {hint localize "STR_NOTF_ActionInProc"};
disableSerialization;

_disp = findDisplay 39400;
_sellBtn = _disp displayCtrl 39403;
_title = _disp displayCtrl 39405;
_control = _disp displayCtrl 39402;

_sellBtn ctrlSetText localize "STR_Keys_GiveKey";
_sellBtn buttonSetAction "closeDialog 0; [life_pInact_curTarget] call life_fnc_handKey;";
_title ctrlSetText localize "STR_Keys_Title";
lbClear _control;

if (isNull _target) then {
    {
        _vehicle = _x;
        if (alive _vehicle) then {
            private _name = getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");
            private _pic = getText(configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "picture");
            _control lbAdd format ["%1 - %2m", _name, round(player distance _vehicle)];
            if (_pic != "pictureStaticObject") then {
                _control lbSetPicture [(lbSize _control) - 1, _pic];
            };
            _control lbSetData [(lbSize _control) - 1, str(_forEachIndex)];
        };
    } forEach life_vehicles;
} else {
    private _idx = lbCurSel _control;
    if (_idx < 0) exitWith {hint localize "STR_NOTF_didNotSelectVehicle";};
    _idx = parseNumber (_control lbData _idx);
    _vehicle = life_vehicles select _idx;

    if (isNull _target || isNil "_target") exitWith {};
    if (_target == player) exitWith {};
    _uid = getPlayerUID _target;
    _owners = _vehicle getVariable "vehicle_info_owners";
    _idx = [_uid, _owners] call TON_fnc_index;
    if (_idx isEqualTo -1) then {
        _owners pushBack [_uid, _target getVariable ["realname", name _target]];
        _vehicle setVariable ["vehicle_info_owners", _owners, true];
    };
    hint format [localize "STR_NOTF_givenKeysTo", _target getVariable ["realname", name _target], typeOf _vehicle];
    [_vehicle,_target,profileName] remoteExecCall ["TON_fnc_clientGetKey",_target];
};
