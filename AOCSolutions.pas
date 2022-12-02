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
  private
    CaloriesPerElf: TList<integer>;
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay2 = class(TAdventOfCode)
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;


//  TAdventOfCodeDay = class(TAdventOfCode)
//  protected
//    procedure BeforeSolve; override;
//    procedure AfterSolve; override;
//    function SolveA: Variant; override;
//    function SolveB: Variant; override;
//  end;

implementation

{$REGION 'TAdventOfCodeDay1'}
procedure TAdventOfCodeDay1.BeforeSolve;
var
  i, TotalCalories, Calories: integer;
begin
  inherited;

  CaloriesPerElf := TList<integer>.Create;

  TotalCalories := 0;
  for i := 0 to FInput.Count - 1 do
  Begin
    if TryStrToInt(FInput[i], Calories) then
      inc(TotalCalories, Calories)
    else
    begin
      CaloriesPerElf.Add(TotalCalories);
      TotalCalories := 0;
    end;
  End;

  CaloriesPerElf.Add(TotalCalories);
  CaloriesPerElf.Sort;
  CaloriesPerElf.Reverse;
end;

procedure TAdventOfCodeDay1.AfterSolve;
begin
  inherited;
  CaloriesPerElf.Free;
end;

function TAdventOfCodeDay1.SolveA: Variant;
begin
  Result := CaloriesPerElf.First;
end;

function TAdventOfCodeDay1.SolveB: Variant;
begin
  Result := CaloriesPerElf[0] + CaloriesPerElf[1] + CaloriesPerElf[2];
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay2'}
type rRPSData = record
  Name: string;
  WinsFrom, LossesFrom, TiesFrom, PlayerScore: integer
end;

Const RPSData: array[0..2] of rRPSData = (
(Name: 'Rock';      WinsFrom: 2; LossesFrom: 1; TiesFrom: 0; PlayerScore: 1),
(Name: 'Paper';     WinsFrom: 0; LossesFrom: 2; TiesFrom: 1; PlayerScore: 2),
(Name: 'Scissors';  WinsFrom: 1; LossesFrom: 0; TiesFrom: 2; PlayerScore: 3));

function TAdventOfCodeDay2.SolveA: Variant;
var
  Elf, Player: Integer;
  s: String;
  Split: TStringDynArray;
begin
  Result := 0;

  for s in FInput do
  begin
    Split := SplitString(s, ' ');
    Elf := Ord(Split[0][1]) - Ord('A');
    Player := Ord(Split[1][1]) - Ord('X');

    inc(Result, RPSData[Player].PlayerScore);
    if Elf = Player then
      inc(Result, 3)
    else if RPSData[Player].WinsFrom = Elf then
      inc(Result, 6)
  end;
end;

function TAdventOfCodeDay2.SolveB: Variant;
var
  Player, Elf, OutCome: Integer;
  s: String;
  Split: TStringDynArray;
begin
  Result := 0;

  for s in FInput do
  begin
    Split := SplitString(s, ' ');
    Elf := Ord(Split[0][1]) - Ord('A');
    OutCome := Ord(Split[1][1]) - Ord('X');

    case OutCome of
      0: Player := RPSData[Elf].WinsFrom;
      1: Player := RPSData[Elf].TiesFrom;
      2: Player := RPSData[Elf].LossesFrom;
    else
      raise Exception.CreateFmt('invalid outcome, %d', [Outcome]);
    end;

    Inc(Result, RPSData[Player].PlayerScore + OutCome * 3);
  end;
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
//var
//  i: Integer;
//  s: String;
//  Split: TStringDynArray;
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
  TAdventOfCodeDay1, TAdventOfCodeDay2
  ]);

end.
