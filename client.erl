-module(client).
-export([connect_riak/0,fetch/2,bucket/0,keys/1,store/3]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (first you should start riak) 
% sudo riak start
% (go to riak folder) 
% cd $PATH_TO_riak-2.0.0(or riak-2.0.1)/dev
% (start five nodes one by one)
% sudo dev1/bin/riak start
% sudo dev2/bin/riak start
% sudo dev3/bin/riak start
% sudo dev4/bin/riak start
% sudo dev5/bin/riak start
% (start erlang shell with riak-erlang-client)
% erl -pa $PATH_TO_riak-erlang-client/ebin/ $PATH_TO_riak-erlang-client/deps/*/ebin
% ($PATH_TO_riak-erlang-client is your riak-erlang-client directory)
% (for example mine is /Users/mengjiao/riak-erlang-client)
% (so i should type that erl -pa /Users/mengjiao/riak-erlang-client/ebin/ /Users/mengjiao/riak-erlang-client/deps/*/ebin)
% go to this erlang file directory
% cd("/.../").
% c(client).

%we connect to riak by open socket, but only one node.
connect_riak()->
        riakc_pb_socket:start_link("127.0.0.1", 10017).

% store(bucket,key,value).
% this is the function to store value with key into bucket, you can define 
% the name of bucket, key and value when you try this code.
store(Bucket,Key,Value)->
                {ok,Pid} = connect_riak(),
                B = atom_to_binary(Bucket,latin1),
                K = atom_to_binary(Key,latin1),
                V = atom_to_binary(Value,latin1),
                Object = riakc_obj:new(B,K,V),
                riakc_pb_socket:put(Pid, Object, [{w, 1}]).

% list buckets
bucket()->
        {ok,Pid} = connect_riak(),
                riakc_pb_socket:list_buckets(Pid).


% keys(bucket).
% this is the function to list all the keys inside bucket.
keys(Bucket)->
                {ok,Pid} = connect_riak(),
                B = atom_to_binary(Bucket,latin1),
                riakc_pb_socket:list_keys(Pid,B).


% fetch(room,kitchen)
fetch(Bucket,Key)->
        {ok,Pid} = connect_riak(),
        B = atom_to_binary(Bucket,latin1),
        K = atom_to_binary(Key,latin1),
        {ok,V}=riakc_pb_socket:get(Pid,B,K),
        _Val = riakc_obj:get_value(V).

