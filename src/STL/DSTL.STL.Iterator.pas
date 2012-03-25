{ *******************************************************************************
  *                                                                             *
  *          Delphi Standard Template Library                                   *
  *                                                                             *
  *          (C)Copyright Jimx 2011                                             *
  *                                                                             *
  *          http://delphi-standard-template-library.googlecode.com             *
  *                                                                             *
  *******************************************************************************
  *  This file is part of Delphi Standard Template Library.                     *
  *                                                                             *
  *  Delphi Standard Template Library is free software:                         *
  *  you can redistribute it and/or modify                                      *
  *  it under the terms of the GNU General Public License as published by       *
  *  the Free Software Foundation, either version 3 of the License, or          *
  *  (at your option) any later version.                                        *
  *                                                                             *
  *  Delphi Standard Template Library is distributed                            *
  *  in the hope that it will be useful,                                        *
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of             *
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
  *  GNU General Public License for more details.                               *
  *                                                                             *
  *  You should have received a copy of the GNU General Public License          *
  *  along with Delphi Standard Template Library.                               *
  *  If not, see <http://www.gnu.org/licenses/>.                                *
  ******************************************************************************* }
unit DSTL.STL.Iterator;

interface

uses SysUtils, DSTL.Config, DSTL.Types, DSTL.STL.ListNode, DSTL.STL.TreeNode,
  DSTL.Utils.Pair;

const
  defaultArrSize = 16;

type

  TContainer<T> = class;
  TContainer<T1, T2> = class;

  TIteratorHandle<T> = class;
  TIteratorHandle<T1, T2> = class;
  IteratorStructure = (isVector, isList, isMap, isSet, isHash);

  TIteratorFlag = (ifBidirectional, ifRandom);
  TIteratorFlags = set of TIteratorFlag;

  TIterator<T> = record
    handle: TIteratorHandle<T>;
    flags: TIteratorFlags;
    class operator Implicit(a: TIterator<T>): T;
    class operator Inc(a: TIterator<T>): TIterator<T>;
    class operator Dec(a: TIterator<T>): TIterator<T>;
    class operator Equal(a: TIterator<T>; b: TIterator<T>): Boolean;
    class operator NotEqual(a: TIterator<T>; b: TIterator<T>): Boolean;
    case IteratorStructure of
      isVector:
        (position: Integer);
      isList:
        (node: TListNode<T>);
  end;

  TIterator<T1, T2> = record
    handle: TIteratorHandle<T1, T2>;
    flags: TIteratorFlags;
    node: TTreeNode<T1, T2>;
    class operator Inc(a: TIterator<T1, T2>): TIterator<T1, T2>;
    class operator Dec(a: TIterator<T1, T2>): TIterator<T1, T2>;
    class operator Equal(a: TIterator<T1, T2>; b: TIterator<T1, T2>): Boolean;
    class operator NotEqual(a: TIterator<T1, T2>; b: TIterator<T1, T2>): Boolean;
  end;

  (*
   *
   * When add a handler to TIteratorHandle,
   * add it to
   *  <1>: TContainer<T>
   *  <2>: TIterOperations<T>
   * too.
   *)
  TIteratorHandle<T> = class
  protected
    procedure iadvance(var Iterator: TIterator<T>); virtual; abstract;
    procedure iretreat(var Iterator: TIterator<T>); virtual; abstract;
    function iget(const Iterator: TIterator<T>): T; virtual; abstract;
    procedure iput(const Iterator: TIterator<T>; const obj: T); virtual; abstract;
    function iremove(const Iterator: TIterator<T>): TIterator<T>;  virtual; abstract;
    function iat_end(const Iterator: TIterator<T>): boolean; virtual; abstract;
    function iequals(const iter1, iter2: TIterator<T>): Boolean;
      virtual; abstract;
    function idistance(const iter1, iter2: TIterator<T>): integer;
      virtual; abstract;
  end;

  TIteratorHandle<T1, T2> = class
  protected
    procedure iadvance(var Iterator: TIterator<T1, T2>); virtual; abstract;
    procedure iretreat(var Iterator: TIterator<T1, T2>); virtual; abstract;
    function iget(const Iterator: TIterator<T1, T2>): TPair<T1, T2>;
      virtual; abstract;
    procedure iput(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>); virtual; abstract;
    function iremove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;  virtual; abstract;
    function iat_end(const Iterator: TIterator<T1, T2>): boolean; virtual; abstract;
    function iequals(const iter1, iter2: TIterator<T1, T2>): Boolean;
      virtual; abstract;
    function idistance(const iter1, iter2: TIterator<T1, T2>): integer;
      virtual; abstract;
  end;

  TContainer<T> = class(TIteratorHandle<T>)
  protected
    procedure iadvance(var Iterator: TIterator<T>); override;
    procedure iretreat(var Iterator: TIterator<T>); override;
    function iget(const Iterator: TIterator<T>): T; override;
    procedure iput(const Iterator: TIterator<T>; const obj: T); override;
    function iremove(const Iterator: TIterator<T>): TIterator<T>;  override;
    function iat_end(const Iterator: TIterator<T>): boolean; override;
    function iequals(const iter1, iter2: TIterator<T>): Boolean; override;
    function idistance(const iter1, iter2: TIterator<T>): integer; override;
  public
    constructor Create;
    procedure add(const obj: T); virtual; abstract;
    procedure remove(const obj: T); virtual; abstract;
    procedure clear; virtual; abstract;
  end;

  TContainer<T1, T2> = class(TIteratorHandle<T1, T2>)
  protected
    procedure iadvance(var Iterator: TIterator<T1, T2>); override;
    procedure iretreat(var Iterator: TIterator<T1, T2>); override;
    function iget(const Iterator: TIterator<T1, T2>): TPair<T1, T2>; override;
    procedure iput(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>); override;
    function iremove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;  override;
    function iat_end(const Iterator: TIterator<T1, T2>): boolean; override;
    function iequals(const iter1, iter2: TIterator<T1, T2>): Boolean; override;
    function idistance(const iter1, iter2: TIterator<T1, T2>): integer; override;
  public
    constructor Create;
  end;

{$WARNINGS OFF}     // disable warning for TIterOperations.equals
  TIterOperations<T> = class
    procedure advance(var Iterator: TIterator<T>);
    procedure retreat(var Iterator: TIterator<T>);
    function get(const Iterator: TIterator<T>): T;
    procedure put(const Iterator: TIterator<T>; const obj: T);
    function remove(const Iterator: TIterator<T>): TIterator<T>;
    function at_end(const Iterator: TIterator<T>): boolean;
    function equals(const iter1, iter2: TIterator<T>): Boolean;
    function distance(const iter1, iter2: TIterator<T>): integer;
  end;

  TIterOperations<T1, T2> = class
    procedure advance(var Iterator: TIterator<T1, T2>);
    procedure retreat(var Iterator: TIterator<T1, T2>);
    function get(const Iterator: TIterator<T1, T2>): TPair<T1, T2>;
    procedure put(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>);
    function remove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;
    function at_end(const Iterator: TIterator<T1, T2>): boolean;
    function equals(const iter1, iter2: TIterator<T1, T2>): Boolean;
    function distance(const iter1, iter2: TIterator<T1, T2>): integer;
  end;
{$WARNINGS ON}

implementation

{$REGION 'TContainer'}

constructor TContainer<T>.Create;
begin

end;

procedure TContainer<T>.iadvance(var Iterator: TIterator<T>);
begin
end;

procedure TContainer<T>.iretreat(var Iterator: TIterator<T>);
begin
end;

function TContainer<T>.iget(const Iterator: TIterator<T>): T;
begin
end;

procedure TContainer<T>.iput(const Iterator: TIterator<T>; const obj: T);
begin

end;

function TContainer<T>.iremove(const Iterator: TIterator<T>): TIterator<T>;
begin

end;

function TContainer<T>.iat_end(const Iterator: TIterator<T>): boolean;
begin

end;

function TContainer<T>.iequals(const iter1, iter2: TIterator<T>): Boolean;
begin
end;

function TContainer<T>.idistance(const iter1, iter2: TIterator<T>): integer;
begin

end;

constructor TContainer<T1, T2>.Create;
begin

end;

procedure TContainer<T1, T2>.iadvance(var Iterator: TIterator<T1, T2>);
begin
end;

procedure TContainer<T1, T2>.iretreat(var Iterator: TIterator<T1, T2>);
begin
end;

function TContainer<T1, T2>.iget(const Iterator: TIterator<T1, T2>)
  : TPair<T1, T2>;
begin
end;

procedure TContainer<T1, T2>.iput(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>);
begin

end;

function TContainer<T1, T2>.iremove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;
begin

end;

function TContainer<T1, T2>.iat_end(const Iterator: TIterator<T1, T2>): boolean;
begin

end;

function TContainer<T1, T2>.iequals(const iter1,
  iter2: TIterator<T1, T2>): Boolean;
begin
end;

function TContainer<T1, T2>.idistance(const iter1, iter2: TIterator<T1, T2>): integer;
begin

end;

{$ENDREGION}

{$REGION 'TIterator'}

class operator TIterator<T>.Implicit(a: TIterator<T>): T;
begin
  Result := a.handle.iget(a);
end;

class operator TIterator<T>.Inc(a: TIterator<T>): TIterator<T>;
begin
  a.handle.iadvance(a);
  Result := a;
end;

class operator TIterator<T>.Dec(a: TIterator<T>): TIterator<T>;
begin
  a.handle.iretreat(a);
  Result := a;
end;

class operator TIterator<T>.Equal(a: TIterator<T>; b: TIterator<T>): Boolean;
begin
  Result := a.handle.iequals(a, b);
end;

class operator TIterator<T>.NotEqual(a: TIterator<T>; b: TIterator<T>): Boolean;
begin
  Result := not a.handle.iequals(a, b);
end;

class operator TIterator<T1, T2>.Inc(a: TIterator<T1, T2>): TIterator<T1, T2>;
begin
  a.handle.iadvance(a);
  Result := a;
end;

class operator TIterator<T1, T2>.Dec(a: TIterator<T1, T2>): TIterator<T1, T2>;
begin
  a.handle.iretreat(a);
  Result := a;
end;

class operator TIterator<T1, T2>.Equal(a: TIterator<T1, T2>;
  b: TIterator<T1, T2>): Boolean;
begin
  Result := a.handle.iequals(a, b);
end;

class operator TIterator<T1, T2>.NotEqual(a: TIterator<T1, T2>;
  b: TIterator<T1, T2>): Boolean;
begin
  Result := not a.handle.iequals(a, b);
end;

{$ENDREGION}

{$REGION 'TIterOperations'}

procedure TIterOperations<T>.advance(var Iterator: TIterator<T>);
begin
  Iterator.handle.iadvance(Iterator);
end;

procedure TIterOperations<T>.retreat(var Iterator: TIterator<T>);
begin
  Iterator.handle.iadvance(Iterator);
end;

function TIterOperations<T>.get(const Iterator: TIterator<T>): T;
begin
  Result := Iterator.handle.iget(Iterator);
end;

procedure TIterOperations<T>.put(const Iterator: TIterator<T>; const obj: T);
begin
  Iterator.handle.iput(Iterator, obj);
end;

function TIterOperations<T>.remove(const Iterator: TIterator<T>): TIterator<T>;
begin
  Result := Iterator.handle.iremove(Iterator);
end;

function TIterOperations<T>.at_end(const Iterator: TIterator<T>): boolean;
begin
  Result := Iterator.handle.iat_end(Iterator);
end;

function TIterOperations<T>.equals(const iter1, iter2: TIterator<T>): Boolean;
begin
  Result := iter1.handle.iequals(iter1, iter2);
end;

function TIterOperations<T>.distance(const iter1, iter2: TIterator<T>): integer;
begin
  Result := iter1.handle.idistance(iter1, iter2);
end;

procedure TIterOperations<T1, T2>.advance(var Iterator: TIterator<T1, T2>);
begin
  Iterator.handle.iadvance(Iterator);
end;

procedure TIterOperations<T1, T2>.retreat(var Iterator: TIterator<T1, T2>);
begin
  Iterator.handle.iadvance(Iterator);
end;

function TIterOperations<T1, T2>.get(const Iterator: TIterator<T1, T2>)
  : TPair<T1, T2>;
begin
  Result := Iterator.handle.iget(Iterator);
end;

procedure TIterOperations<T1, T2>.put(const Iterator: TIterator<T1, T2>; const obj: TPair<T1, T2>);
begin
  Iterator.handle.iput(Iterator, obj);
end;

function TIterOperations<T1, T2>.remove(const Iterator: TIterator<T1, T2>): TIterator<T1, T2>;
begin
  Result := Iterator.handle.iremove(Iterator);
end;

function TIterOperations<T1, T2>.at_end(const Iterator: TIterator<T1, T2>): boolean;
begin
  Result := Iterator.handle.iat_end(Iterator);
end;

function TIterOperations<T1, T2>.equals(const iter1,
  iter2: TIterator<T1, T2>): Boolean;
begin
  Result := iter1.handle.iequals(iter1, iter2);
end;

function TIterOperations<T1, T2>.distance(const iter1, iter2: TIterator<T1, T2>): integer;
begin
  Result := iter1.handle.idistance(iter1, iter2);
end;

{$ENDREGION}

end.