(***********************************************************************)
(*                                                                     *)
(*                     Astar (A* algorithm)                            *)
(*                                                                     *)
(*         David Gianazza, Ecole Nationale de l'Aviation Civile        *)
(*                                                                     *)
(*  Copyright 2017 Ecole Nationale de l'Aviation Civile.               *)
(*  All rights reserved.  This file is distributed under the terms of  *)
(*  the GNU Library General Public License.                            *)
(*                                                                     *)
(***********************************************************************)

type 'a state = 'a

type prio= float
      
type 'a user_fun = {
  do_at_extraction:
      (prio, 'a) Pqueue.t -> 'a Memory.t -> 'a state -> unit;
  do_at_insertion: 'a state -> 'a state -> unit;
}

(*-------------------*)
(* The A* algorithm  *)

exception Eureka
      
let search user_fun u0 is_goal next k h =
  (* Initialize the priority queue and the memory table *)
  let cost0= 0. in
  let f0= cost0 +. h u0 in
  let m= Memory.init u0 cost0 in
  let q= ref (Pqueue.insert f0 u0 Pqueue.empty) in
  let path = ref [] in
  try
    while not (Pqueue.is_empty !q) do
      let (_prio,u,new_q)= Pqueue.extract !q in
      user_fun.do_at_extraction !q m u;
  (* !!!!!!   PARTIE A MODIFIER !!!!!! *)
        if is_goal u then 
                begin
                        path := Memory.get_path m u;
                          raise Eureka;
                end;
        if not (Memory.already_expanded m u) then 
           begin
               Memory.tag_as_expanded m u;
               let ls = next u in
               let f = fun v ->
                       let costv = Memory.get_cost m v 
                       and costu = Memory.get_cost m u in
                       if ((not (Memory.mem m v))||costv>costu +. (k u v)) then
                              begin
                                      let costv = costu +. (k u v) in
                                      let fv = costv +. (h u) in
                                      let fatherv = u in
                                      Memory.store_state m v costv fatherv;
                                      q:=Pqueue.insert fv v !q;
                              end; 
                       in 
                       List.iter f ls;
           end;
  (* !!!!!!   FIN DE LA PARTIE A MODIFIER !!!!!! *)
    done;
    failwith "Unreachable"
  with Eureka -> !path



(*----------------------*)
(* Functorial interface *)
    
module type Model= sig
  type state
  type user_param

  val initial_state: user_param -> state

  val is_goal: user_param -> state -> bool
  val next: user_param -> state -> state list
  val k: user_param -> state -> state -> float
  val h: user_param -> state -> float

  val do_at_insertion:
      user_param -> state -> state -> unit
   
  val do_at_extraction:
      user_param -> (prio, state) Pqueue.t -> state Memory.t -> state -> unit
end

module type Astar = sig
  include Model
  val search: user_param -> state list
end


module Make (M:Model):(Astar with type state=M.state
and type user_param= M.user_param) = struct
  include M

  let search user_param =
    let u0= M.initial_state user_param in
    let is_goal = M.is_goal user_param
    and next= M.next user_param
    and k= M.k user_param
    and h= M.h user_param in
    let user_fun= {do_at_extraction= M.do_at_extraction user_param;
                   do_at_insertion= M.do_at_insertion user_param } in
    search user_fun u0 is_goal next k h
end

