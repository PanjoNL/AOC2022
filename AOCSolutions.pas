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
  private
    type TGame = reference to function(aLeft, aRight: Integer): integer;
    function PlayRockPaperScissors(aGame: TGame): Integer;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay3 = class(TAdventOfCode)
  private
    Type SetOfByte = Set of Byte;

    function GetRucksackContent(aContent: string): SetOfByte;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay4 = class(TAdventOfCode)
  private
    type TCheckAssignment = reference to function(const L1, R1, L2, R2: integer): boolean;

    function CheckAssignments(CheckAssignment: TCheckAssignment): integer;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay5 = class(TAdventOfCode)
  private
    type
      TShelf = TStack<string>;
      TWareHouse = TObjectDictionary<integer, TShelf>;
      TCrateMover = reference to procedure(ShelfFrom, ShelfTo: TShelf; aTotal: integer);

    function MoveCreates(CrateMover: TCrateMover): string;
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
function TAdventOfCodeDay2.SolveA: Variant;
begin
  Result := PlayRockPaperScissors(
    function(aElf, aPlayer: integer): integer
    begin
      Result := aPlayer + 1 + 3 * ((4 + aPlayer - aElf) Mod 3);
    end);
end;

function TAdventOfCodeDay2.SolveB: Variant;
begin
  Result := PlayRockPaperScissors(
    function(aElf, aOutcome: integer): integer
    begin
      Result := 3 * aOutcome + 1 + ((2 + aOutcome + aElf) mod 3);
    end);
end;

function TAdventOfCodeDay2.PlayRockPaperScissors(aGame: TGame): Integer;
var
  s: String;
  Split: TStringDynArray;
begin
  Result := 0;

  for s in FInput do
  begin
    Split := SplitString(s, ' ');
    Inc(Result, aGame(Ord(Split[0][1]) - Ord('A'), Ord(Split[1][1]) - Ord('X')));
  end;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay3'}
function TAdventOfCodeDay3.GetRucksackContent(aContent: string): SetOfByte;
var
  c: Char;
  score: Byte;
begin
  Result := [];
  for c in aContent do
  begin
    if LowerCase(c)= c then
      score := Ord(c) - Ord('a') + 1
    else
      score := Ord(c) - Ord('A') + 1 + 26;

    Include(Result, Score);
  end;
end;

function TAdventOfCodeDay3.SolveA: Variant;
var
  score, ItemCount: Integer;
  s: String;
  Left, Right: SetOfByte;

begin
  Result := 0;
  for s in FInput do
  begin
    ItemCount := Length(s) shr 1;

    Left :=  GetRucksackContent(Copy(s, 0, ItemCount));
    Right := GetRucksackContent(Copy(s, ItemCount + 1, 2 * ItemCount));

    for score in Left * Right do
      Inc(Result, Score);
  end;
end;

function TAdventOfCodeDay3.SolveB: Variant;
var
  i, score: Integer;
begin
  Result := 0;
  i := 0;

  while i < FInput.Count do
  begin
    for score in GetRucksackContent(FInput[i]) * GetRucksackContent(FInput[i+1]) * GetRucksackContent(FInput[i+2]) do
      Inc(Result, Score);
    inc(i, 3);
  end;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay4'}
function TAdventOfCodeDay4.SolveA: Variant;
begin
  Result := CheckAssignments(function(const L1, R1, L2, R2: integer): boolean
    begin
      Result := ((L1 >= L2) and (R1 <= R2)) or ((L2 >= L1) and (R2 <= R1))
    end);
end;

function TAdventOfCodeDay4.SolveB: Variant;
begin
  Result := CheckAssignments(function(const L1, R1, L2, R2: integer): boolean
    begin
      Result := InRange(L1, L2, R2) or InRange(R1, L2, R2) or InRange(L2, L1, R1) or InRange(R2, L1, R1)
    end);
end;

function TAdventOfCodeDay4.CheckAssignments(CheckAssignment: TCheckAssignment): integer;
var
  s: String;
  Split: TStringDynArray;
begin
  Result := 0;

  for s in FInput do
  begin
    Split := SplitString(s, '-,');

    if CheckAssignment(Split[0].ToInteger, Split[1].ToInteger, Split[2].ToInteger, Split[3].ToInteger) then
      Inc(Result);
  end;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay5'}
function TAdventOfCodeDay5.SolveA: Variant;
begin
  Result := MoveCreates(
    procedure(ShelfFrom, ShelfTo: TShelf; aTotal: integer)
    begin
      while aTotal > 0 do
      begin
        ShelfTo.Push(ShelfFrom.Pop);
        Dec(aTotal);
      end;
    end);
end;

function TAdventOfCodeDay5.SolveB: Variant;
begin
  Result := MoveCreates(
    procedure(ShelfFrom, ShelfTo: TShelf; aTotal: integer)
    var
      CraneStack: TShelf;
    begin
      CraneStack := TShelf.Create;
      while aTotal > 0 do
      begin
        CraneStack.Push(ShelfFrom.Pop);
        Dec(aTotal);
      end;

      while CraneStack.Count > 0 do
        ShelfTo.Push(CraneStack.Pop);
      CraneStack.Free;
    end);
end;

function TAdventOfCodeDay5.MoveCreates(CrateMover: TCrateMover): string;
var
  WareHouse: TWareHouse;
  StackNo, ShelfLevel, StackCount, InstructionStart, i: integer;
   Split: TStringDynArray;
begin
  StackCount := (Length(FInput[0]) + 1) div 4;
  WareHouse := TWareHouse.Create([doOwnsValues]);

  // Create Shelfs
  for StackNo := 1 to StackCount do
    WareHouse.Add(StackNo, TShelf.Create);

  // Find the start of the moving instructions
  InstructionStart := 0;
  for i := 0 to FInput.Count -1 do
    if Trim(FInput[i]) = '' then
    begin
      InstructionStart := i + 1;
      break;
    end;

  // Read shelfdata from input
  for ShelfLevel := InstructionStart - 3 downto 0 do
    for StackNo := 1 to StackCount do
      if Trim(FInput[ShelfLevel][StackNo*4 -2]) <> '' then
        WareHouse[StackNo].Push(FInput[ShelfLevel][StackNo*4 -2]);

  // Move crates
  for i := InstructionStart to FInput.Count -1 do
  begin
    Split := SplitString(FInput[i], ' ');
    CrateMover(WareHouse[Split[3].ToInteger], WareHouse[Split[5].ToInteger], Split[1].ToInteger);
  end;

  // Determine crate at the top of each shelf
  Result := '';
  for StackNo := 1 to StackCount do
    Result := Result + WareHouse[StackNo].Peek;

  WareHouse.Free;
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
  TAdventOfCodeDay1, TAdventOfCodeDay2, TAdventOfCodeDay3, TAdventOfCodeDay4, TAdventOfCodeDay5
  ]);

end.
