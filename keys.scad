// the point of this file is to be a sort of DSL for constructing keycaps.
// when you create a method chain you are just changing the parameters
// key.scad uses, it doesn't generate anything itself until the end. This
// lets it remain easy to use key.scad like before (except without key profiles)
// without having to rely on this file. Unfortunately that means setting tons of
// special variables, but that's a limitation of SCAD we have to work around

include <./includes.scad>



length = len(keys);


// example key
//dcs_row(5) legend("⇪", size=9) key();
/*
// example row
  translate_u(0,-x) dcs_row(x) key();
}*/ 
for(index=[0:length-1])
{
    translate_u(keys[index][1][0],-keys[index][1][1])
        rotate([0,0,-keys[index][1][3]])
            translate_u(.5,-.5)
                translate_u(keys[index][0][0],-keys[index][0][1])
                    dcs_row(r)  
                        legend(keys[index][2][0][0], size=keys[index][2][0][1],keys[index][2][0][2])
                            legend(keys[index][2][1][0], size=keys[index][2][1][1],keys[index][2][1][2])
                                legend(keys[index][2][2][0], size=keys[index][2][2][1],keys[index][2][2][2])
                                    legend(keys[index][2][3][0], size=keys[index][2][3][1],keys[index][2][3][2])
                                        legend(keys[index][2][4][0], size=keys[index][2][4][1],keys[index][2][4][2]) 
                                            legend(keys[index][2][5][0], size=keys[index][2][5][1],keys[index][2][5][2])
                                                legend(keys[index][2][6][0], size=keys[index][2][6][1],keys[index][2][6][2])
                                                    legend(keys[index][2][7][0], size=keys[index][2][7][1],keys[index][2][7][2])
                                                        legend(keys[index][2][8][0], size=keys[index][2][8][1],keys[index][2][8][2])
                                                            key($stem_type = "rounded_cherry");
}

// example layout
// preonic_default("dcs") key(); 
