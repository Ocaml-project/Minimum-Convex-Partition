(** Module regroupant les types les plus importants utilis�s dans la plus part des modules *)

(** Le record point est cr�er de la m�me mani�re que dans le json *)
type point = {
  i : int; (**i est l'indice du point *)
  x : int; (**x est l'absisse du point*)
  y : int; (**y est l'ordonn� du point*)
}

(** Couple des identifiants des deux points. Le type edge est cr�er de la m�me mani�re que dans le json *)
type edge = int * int

(** La representation d'un graphe. *)
type graph = {
  points : point list; (** la liste des points du graphe *)
  edges : edge list; (** la liste des arr�tes du graphe *)
}