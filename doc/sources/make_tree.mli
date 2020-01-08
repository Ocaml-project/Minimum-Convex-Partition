(** Module permettant la recherche de la meilleur solution via la construction d'un arbre de possibilit�. La construction de la solution se fait par ajout d'arr�te. *)

(** Repr�sentation de l'arbre des possibilit�s. *)
type arbre = 
  | Vide (** l'arbre vide *)
  | Node of Types.edge * arbre list (** le noeud de l'arbre est une arr�te, les sous-arbres sont repr�sent�s par une liste d'arbre *)
  | End (** arbre vide qui d�limite une solution *)

(** Ce type est un point am�lior� qui poss�de les m�me information que le point, l'appartenance � l'enveloppe convexe en plus. *)
type point_graph = {
  x : int; (** x est l'absisse du point *)
  y : int; (**y est l'ordonn� du point*)
  indice : int; (**indice est l'indice du point *)
  env : bool; (** env est un bool�en pour savoir si le point appartient � l'enveloppe convexe *)
}


val is_in_env_conv : 'a -> 'a list -> bool
val create_all_edges : point_graph list -> (int * int) array
val conditions : 'a -> 'b -> 'c -> int
val pt_to_ptgraph : Types.point list -> Types.point -> point_graph
val gen_arbre : Types.graph -> Types.point list -> arbre list
val get_sol : arbre list -> Types.edge list option
