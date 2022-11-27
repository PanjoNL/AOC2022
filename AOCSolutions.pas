unit AOCSolutions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes,
  Generics.Defaults, System.Generics.Collections,
  System.Diagnostics, AOCBase, RegularExpressions, System.DateUtils,
  System.StrUtils,
  System.Math, uAOCUtils, System.Types, PriorityQueues, System.Json;

type
  TAdventOfCodeDay1 = class(TAdventOfCode)
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
  end;

//  TAdventOfCodeDay = class(TAdventOfCode)
//  protected
//    function SolveA: Variant; override;
//    function SolveB: Variant; override;
//    procedure BeforeSolve; override;
//    procedure AfterSolve; override;
//  end;

implementation

{$REGION 'TAdventOfCodeDay1'}
procedure TAdventOfCodeDay1.BeforeSolve;
begin
  inherited;

end;

procedure TAdventOfCodeDay1.AfterSolve;
begin
  inherited;

end;

function TAdventOfCodeDay1.SolveA: Variant;
var
  i: integer;
begin
  for i := 0 to FInput.Count - 2 do
    if StrToInt(FInput[i]) < StrToInt(FInput[i+1]) then
      Inc(Result);
end;

function TAdventOfCodeDay1.SolveB: Variant;
begin
//
end;
{$ENDREGION}

{$REGION 'TAdventOfCodeDay'}
//procedure TAdventOfCodeDay.BeforeSolve;
//begin
//  inherited;
//
//end;
//
//procedure TAdventOfCodeDay.AfterSolve;
//begin
//  inherited;
//
//end;
//
//
//function TAdventOfCodeDay.SolveA: Variant;
//begin
//
//end;
//
//function TAdventOfCodeDay.SolveB: Variant;
//begin
////
//end;
{$ENDREGION}


initialization

RegisterClasses([
  TAdventOfCodeDay1
  ]);

end.
