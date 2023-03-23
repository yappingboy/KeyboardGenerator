KLE = import("keyboard-layout.json");
unit=3;
layout = [[0,0]];
for(x=[0:len(KLE)-1])
{
    for(y=[0:len(KLE[x])-1])
    {
       layout = concat(layout[[x,y]]);
    }
}

echo(layout);