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

    function MoveCrates(CrateMover: TCrateMover): string;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay6 = class(TAdventOfCode)
  private
    function FindMarkerPosition(Const aMarkerLength: integer): integer;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAOCDir = class
  strict private
    ChildDirs: TObjectDictionary<string, TAOCDir>;
    FParent: TAOCDir;
    FTotalSize: Int64;
  public
  constructor Create(aParent: TAOCDir);
  destructor Destroy; override;

  function GotoDir(const aDirName: string): TAOCDir;
  function AddDir(aDirName: string): TAOCDir;
  procedure AddFile(const aFileSize: int64);

  property Parent: TAOCDir read FParent;
  property TotalSize: Int64 read FTotalSize;
end;

  TAdventOfCodeDay7 = class(TAdventOfCode)
  private
    RootDir: TAOCDir;
    AllDirs: TList<TAOCDir>;
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay8 = class(TAdventOfCode)
  private
    Trees: array of array of Integer;
    MaxX, MaxY: integer;
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay9 = class(TAdventOfCode)
  private
    function MoveRope(aKnotCount: integer): Integer;
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

  const
    DeltaX: Array[0..3] of integer = (1, -1, 0, 0);
    DeltaY: Array[0..3] of integer = (0, 0, -1, 1);

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
  Result := MoveCrates(
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
  Result := MoveCrates(
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

function TAdventOfCodeDay5.MoveCrates(CrateMover: TCrateMover): string;
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
{$REGION 'TAdventOfCodeDay6'}
function TAdventOfCodeDay6.SolveA: Variant;
begin
  Result := FindMarkerPosition(4);
end;

function TAdventOfCodeDay6.SolveB: Variant;
begin
  Result := FindMarkerPosition(14);
end;

function TAdventOfCodeDay6.FindMarkerPosition(const aMarkerLength: integer): integer;
var
  MarkerEnd, MarkerBitNo, SeenBits, BitIndex : Integer;
  TheMessage: String;
begin
  Result := 0;
  TheMessage := FInput[0];

  for MarkerEnd := aMarkerLength to Length(TheMessage) do
  begin
    SeenBits := 0;

    for MarkerBitNo := 0 to aMarkerLength -1 do
    begin
      BitIndex := Ord(TheMessage[MarkerEnd-MarkerBitNo]) - Ord('a');
      if (SeenBits shr BitIndex) and 1 = 1 then
        Break;

      if MarkerBitNo = aMarkerLength -1 then
        Exit(MarkerEnd);

      SeenBits := SeenBits or 1 shl BitIndex;
    end;
  end
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay7'}
{ TAOCDir }
constructor TAOCDir.Create(aParent: TAOCDir);
begin
  FTotalSize := 0;
  FParent := aParent;
  ChildDirs := TObjectDictionary<string,TAOCDir>.Create([doOwnsValues]);
end;

destructor TAOCDir.Destroy;
begin
  ChildDirs.Free;
end;

function TAOCDir.AddDir(aDirName: string): TAOCDir;
begin
  Result := TAOCDir.Create(self);
  ChildDirs.Add(aDirName, Result);
end;

procedure TAOCDir.AddFile(const aFileSize: int64);
begin
  Inc(FTotalSize, aFileSize);

  if Assigned(Parent) then
    Parent.AddFile(aFileSize);
end;

function TAOCDir.GotoDir(const aDirName: string): TAOCDir;
begin
  Result := ChildDirs[aDirName];
end;

procedure TAdventOfCodeDay7.BeforeSolve;
var
  i: Integer;
  Split: TStringDynArray;
  Current: TAOCDir;
  FileSize: int64;
begin
  RootDir := TAOCdir.Create(nil);
  AllDirs := TList<TAOCDir>.Create();

  Current := RootDir;
  for i := 1 to FInput.Count -1 do
  begin
    split := SplitString(FInput[i], ' ');
    if split[0].StartsWith('$') and (Split[1] = 'cd') then
    begin
      if split[2] = '..' then
        Current := Current.Parent
      else
        Current := Current.GotoDir(split[2]);
    end
    else if split[0].StartsWith('dir')then
      AllDirs.Add(Current.AddDir(split[1]))
    else if TryStrToInt64(split[0], FileSize)then
      Current.AddFile(FileSize);
  end;
end;

procedure TAdventOfCodeDay7.AfterSolve;
begin
  inherited;

  RootDir.Free;
  AllDirs.Free;
end;

function TAdventOfCodeDay7.SolveA: Variant;
var
  Current: TAOCDir;
begin
  Result := 0;
  for Current in AllDirs do
    if Current.TotalSize <= 100000 then
      inc(Result, Current.TotalSize);
end;

function TAdventOfCodeDay7.SolveB: Variant;
var
  Needed: int64;
  Current: TAOCDir;
begin
  Needed := 30000000 - (70000000 - RootDir.TotalSize);

  Result := MaxInt64;
  for Current in AllDirs do
    if Current.TotalSize >= Needed then
      Result := Min(Result, Current.TotalSize);
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay8'}
procedure TAdventOfCodeDay8.BeforeSolve;
var
  X, Y: integer;
begin
  inherited;

  MaxX := Length(FInput[0])-1;
  MaxY := FInput.Count -1;

  SetLength(Trees, MaxY);
  for y := 0 to MaxY do
  begin
    SetLength(Trees[Y], MaxX);
    for X := 0 to MaxX do
      Trees[Y][X] := StrToInt(FInput[Y][X+1]);
  end;
end;

procedure TAdventOfCodeDay8.AfterSolve;
var
  y: integer;
begin
  inherited;

  for Y := 0 to MaxY do
    SetLength(Trees[y], 0);
  SetLength(Trees, 0);
end;

function TAdventOfCodeDay8.SolveA: Variant;
var
  x, y: integer;

  function IsTreeVisible(aX, aY: integer): boolean;
  var
    X, Y, i, CurrentHeight: integer;
  begin
    for i := 0 to 3 do
    begin
      X := aX;
      y := aY;

      while true do
      begin
        inc(X, DeltaX[i]);
        inc(Y, DeltaY[i]);
        CurrentHeight := Trees[aY][aX] ;

        Result := not InRange(X, 0, MaxX) or not InRange(Y, 0, MaxY);
        if Result then
          Exit;

        if Trees[Y][X] >= CurrentHeight then
          break;
      end;
    end;
  end;

begin
  Result := 0;
  for x := 0 to MaxX do
    for y := 0 to MaxY do
      if IsTreeVisible(x, y) then
        Inc(Result);
end;

function TAdventOfCodeDay8.SolveB: Variant;
var
  i, Score, TreeX, TreeY: Integer;

  function VisibleTrees(TreeHeight, aX, aY, aDX, aDY: integer): Integer;
  begin
    Result := 0;
    Inc(aX, aDX);
    Inc(aY, aDY);

    while InRange(aX, 0, MaxX) and InRange(aY, 0, MaxY) do
    begin
      if Trees[aY][aX] < TreeHeight then
        inc(Result);

      if Trees[aY][aX] >= TreeHeight then
      begin
        Inc(Result);
        Exit;;
      end;

      Inc(aX, aDX);
      Inc(aY, aDY);
    end;
  end;

begin
  Result := 0;
  for TreeX := 0 to MaxX do
    for TreeY := 0 to MaxY do
    begin
      Score := 1;
      for i := 0 to 3 do
        Score := Score * VisibleTrees(Trees[TreeY][TreeX], TreeX, TreeY, DeltaX[i], DeltaY[i]);

      Result := Max(Result, Score);
    end;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay9'}
function TAdventOfCodeDay9.SolveA: Variant;
begin
  Result := MoveRope(1);
end;

function TAdventOfCodeDay9.SolveB: Variant;
begin
  Result := MoveRope(9);
end;

const Directions: array[0..3] of TPoint = (
  (X: 0; Y: 1),  // Up
  (X: 0; Y: -1), // Down
  (X: -1; Y: 0), // Left
  (X: 1; Y: 0)); // Right

function TAdventOfCodeDay9.MoveRope(aKnotCount: integer): Integer;
var
  i, tailNo, Step: Integer;
  Split: TStringDynArray;
  Visited: TDictionary<TPoint, Boolean>;
  Tails: Array of TPoint;
  Head, Tail, tmpHead, Direction: TPoint;
  MoveX, MoveY: Boolean;
begin
  Visited := TDictionary<TPoint, Boolean>.Create;
  SetLength(Tails, aKnotCount);

  Head := TPoint.Zero;
  for i := 0 to aKnotCount-1 do
    Tails[i] := TPoint.Zero;

  for i := 0 to FInput.Count -1 do
  begin
    // Determine direction of the head
    Split := SplitString(FInput[i], ' ');
    Direction := Directions[IndexStr(split[0], ['U','D','L', 'R'])];

    for Step := 0 to StrToInt(Split[1])-1 do
    begin
      Head.Offset(Direction);

      for TaiLNo := 0 to aKnotCount-1 do
      begin
        Tail := Tails[tailNo];
        tmpHead := Head;
        if tailNo > 0 then
          tmpHead := Tails[tailNo-1];

        // Check horizontal/vertical
        MoveX := (abs(tmpHead.X-Tail.X) = 2);
        MoveY := (abs(tmpHead.Y-Tail.Y) = 2);

        // Check diagonal
        MoveX := MoveX or (MoveY and (tmpHead.X <> Tail.X));
        MoveY := MoveY or (MoveX and (tmpHead.Y <> Tail.Y));

        if MoveX then
          Tail.X := Tail.X + Sign(tmpHead.X-Tail.X);
        if MoveY then
          Tail.Y := Tail.Y + Sign(tmpHead.Y-Tail.Y);

        Tails[tailNo] := Tail;
        if (TaiLNo = aKnotCount-1) then
          Visited.AddOrSetValue(Tail, True);

        if not (MoveX or MoveY) then
          Break;
      end;
    end;
  end;

  Result := Visited.Count;
  Visited.Free;
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
  TAdventOfCodeDay1, TAdventOfCodeDay2, TAdventOfCodeDay3, TAdventOfCodeDay4, TAdventOfCodeDay5,
  TAdventOfCodeDay6, TAdventOfCodeDay7, TAdventOfCodeDay8, TAdventOfCodeDay9]);

end.
