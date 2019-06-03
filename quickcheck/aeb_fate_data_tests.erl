%%% @author Thomas Arts
%%% @doc Allow to run QuickCheck tests as eunit tests
%%%      `rebar3 as eqc eunit --cover`
%%%      or `rebar3 as eqc eunit --module=aeb_fate_data`
%%%      Note that for obtainign cover file, one needs `rebar3 as eqc cover
%%%
%%%
%%% @end
%%% Created : 13 Dec 2018 by Thomas Arts <thomas@SpaceGrey.lan>

-module(aeb_fate_data_tests).

-include_lib("eunit/include/eunit.hrl").

-compile([export_all, nowarn_export_all]).

-define(EQC_EUNIT(Module, PropName, Ms),
        { atom_to_list(PropName),
          {timeout, (Ms * 3) / 1000, ?_assert(eqc:quickcheck(eqc:testing_time(Ms / 1000, Module:PropName())))}}).

quickcheck_test_() ->
    {setup, fun() -> eqc:start() end,
     [ ?EQC_EUNIT(aefate_eqc, prop_roundtrip, 500),
       ?EQC_EUNIT(aefate_eqc, prop_format_scan, 2000),
       ?EQC_EUNIT(aefate_eqc, prop_order, 2000),
       ?EQC_EUNIT(aefate_eqc, prop_fuzz, 2000)
     ]}.
