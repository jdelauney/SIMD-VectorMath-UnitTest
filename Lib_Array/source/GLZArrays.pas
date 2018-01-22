(*====< GLZArrays.pas >=========================================================@br
  @created(2017-04-17)
  @author(J.Delauney (BeanzMaster) - Peter Dyson (Dicepd) )
  Historique : @br
  @unorderedList(
    @item(21/01/2018 : Creation  )
  )
--------------------------------------------------------------------------------@br

  @bold(Description :)@br
  Generics base classes for managing array thrue pointer

  ------------------------------------------------------------------------------@br
  @bold(Notes) : @br

  ------------------------------------------------------------------------------@br
  @bold(BUGS :)@br
  @unorderedList(
     @item()
  )
  ------------------------------------------------------------------------------@br
  @bold(TODO :)@br
  @unorderedList(
     @item()
  )

  ------------------------------------------------------------------------------@br
  @bold(Credits :)
   @unorderedList(
     @item(FPC/Lazarus)
   )

  ------------------------------------------------------------------------------@br
  @bold(LICENCE :) MPL / GPL @br
  @br
 *==============================================================================*)
unit GLZArrays;

{$mode objfpc}{$H+}
{$IFDEF CPU64}
  {$CODEALIGN LOCALMIN=16} // ??? needed here ????
{$ENDIF}

interface

uses
  Classes, SysUtils,
  GLZTypes, GLZArrayClasses, GLZVectorMath;

Type
  // 1 Dimension
  generic TGLZArrayByte<T> = class(specialize TGLZBaseArray<T>);
  generic TGLZArrayInt<T> = class(specialize TGLZBaseArray<T>);
  generic TGLZArrayFloat<T> = class(specialize TGLZBaseArray<T>);
  // 2 Dimensions
  generic TGLZArrayMap2DByte<T> = class(specialize TGLZBaseArrayMap2D<T>);
  generic TGLZArrayMap2DInt<T> = class(specialize TGLZBaseArrayMap2D<T>);
  generic TGLZArrayMap2DFloat<T> = class(specialize TGLZBaseArrayMap2D<T>);

Type
  TGLZByteList = class(specialize TGLZArrayByte<Byte>);
  TGLZIntegerList = class(specialize TGLZArrayInt<Integer>);
  TGLZSingleList = class(specialize TGLZArrayFloat<Single>);
  TGLZDoubleList = class(specialize TGLZArrayFloat<Double>);

  TGLZByte2DMap = class(specialize TGLZArrayMap2DByte<Byte>);
  TGLZInteger2DMap = class(specialize TGLZArrayMap2DInt<Integer>);
  TGLZSingle2DMap = class(specialize TGLZArrayMap2DFloat<Single>);
  TGLZDouble2DMap = class(specialize TGLZArrayMap2DFloat<Double>);


  TGLZVectorList = class(specialize TGLZArrayFloat<TGLZVector4f>);

implementation

end.

