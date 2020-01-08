open Types

let () = 
  Graphics.open_graph "";
  ignore(Graphics.wait_next_event [Key_pressed]);
  
  let points = (Scanner.input_points "points.json") in
  Graph.plot_graph {points=points; edges=[]};
  ignore(Graphics.wait_next_event [Key_pressed]);
  
  let vide = {points=points; edges=[]} in
  let env, _ = Enveloppe.enveloppe_convexe_graham vide in
  let test = {points=points; edges=(Enveloppe.enveloppe_convexe_2 env)} in

  Graph.clear ();
  Graph.plot_graph test;

  

  ignore(Graphics.wait_next_event [Key_pressed]);
  Graphics.close_graph ();
