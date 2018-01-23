unit GLZVectorMathUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;


function VectorIsColinear(constref v1, v2: TGLZVector) : Boolean;

implementation

function VectorIsColinear(constref v1, v2: TGLZVector) : Boolean;
var
  a, b, c : Single;
begin
  a := v1.DotProduct(v1);
  b := v1.DotProduct(v2);
  c := v2.DotProduct(v2);
  Result :=  (a*c - b*b) < cColinearBias;
end;

end.

