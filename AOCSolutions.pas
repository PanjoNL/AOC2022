unit AOCSolutions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, RTTI,
  Generics.Defaults, System.Generics.Collections,
  System.Diagnostics, AOCBase, RegularExpressions, System.DateUtils,
  System.StrUtils,
  System.Math, uAOCUtils, System.Types, PriorityQueues, System.Json,
  AocLetterReader;

type
  SetOfByte = Set of Byte;

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

  TAdventOfCodeDay10 = class(TAdventOfCode)
  private
    Memory: Array[1..240] of integer;
  protected
    procedure BeforeSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay11 = class(TAdventOfCode)
  private
    function ChaseMonkeys(PartB: boolean): int64;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TBitGrid = array of array of boolean;
  TAdventOfCodeDay12 = class(TAdventOfCode)
  private
    MaxX, MaxY: Integer;
    Heights: array of array of Integer;
    PointS, PointE: TPoint;
    Points_a: TBitGrid;

    function FindPath(aFrom: TPoint; aTo: TBitGrid; IsUphill: boolean): Integer;
    function BlankBitGrid: TBitGrid;
  protected
    procedure BeforeSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TPacketComparer = class(TInterfacedObject, IComparer<TJsonValue>)
    function Compare(const Left, Right: TJsonValue): Integer;
  end;

  TAdventOfCodeDay13 = class(TAdventOfCode)
  private
    PacketComparer: TPacketComparer;
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay14 = class(TAdventOfCode)
  private
    function FillCave(PartB: Boolean): integer;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TSensorData = record
    SensorX, SensorY, BeaconX, BeaconY, ScanDistance: int64;
    class function LoadFromString(aStr: string): TSensorData; static;
  end;

  TAdventOfCodeDay15 = class(TAdventOfCode)
  private
    FScan: TList<TSensorData>;
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  rValveData = record
    Id, GlobalId: Byte;
    Name: string;
    FlowRate: Integer;
    ConnectedTo: Array of string;
    class function LoadFromString(GlobalId: Byte; aStr: string): rValveData; static;
  end;

  rValveState = record
    OpenValves: SetofByte;
    TotalFlow: Integer;
    class function create(aOpenValves: SetOfByte; aTotalFlow: Integer): rValveState; static;
  end;

  TAdventOfCodeDay16 = class(TAdventOfCode)
  private
    ValveAA: Byte;
    AllValves: TDictionary<string, rValveData>;
    InteresstingValves: TList<rValveData>;
    DistanceMatrix: array of array of Integer;
    PartBData: PriorityQueue<rValveState>;

  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay17 = class(TAdventOfCode)
  private
    PartA, PartB: Int64;
  protected
    procedure BeforeSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay18 = class(TAdventOfCode)
  private
    PartA, PartB: Int64;
  protected
    procedure BeforeSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TOreType = (ore, clay, obsidian, geode);
  TOreArray = array[TOreType] of integer;

  rBlueprint = record
    BluePrintId: integer;
    Costs: array[TOreType] of TOreArray;
    class function LoadFromString(aStr: string): rBlueprint; static;
  end;

  TAdventOfCodeDay19 = class(TAdventOfCode)
  private
    function AnalyzeBlueprint(aBlueprint: rBlueprint; runtime: integer): integer;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay20 = class(TAdventOfCode)
  private
    function DecryptMessage(Const DecreptionKey, Rounds: int64): int64;
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TMonkeyMathOperation = (Add, Subtract, Multiply, Divide);
  RMonkeyFormula = record
    part1, part2: string;
    operation: TMonkeyMathOperation;
    class function Create(aPart1, aPart2: string; aOperator: TMonkeyMathOperation): RMonkeyFormula; static;
  end;

  TAdventOfCodeDay21 = class(TAdventOfCode)
  private
    Formulas: TDictionary<string,RMonkeyFormula>;
    KnownNumbers: TDictionary<string,int64>;
    function CalcSimpleFormula(Val1, Val2: Int64; aOperator: TMonkeyMathOperation): int64;
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay22 = class(TAdventOfCode)
  protected
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  TAdventOfCodeDay23 = class(TAdventOfCode)
  private
    PartA, PartB: Int64;
  protected
    procedure BeforeSolve; override;
    function SolveA: Variant; override;
    function SolveB: Variant; override;
  end;

  rBlizard = record
    OffsetX, OffsetY: Integer;
    Position: TPoint;
  end;

  TAdventOfCodeDay24 = class(TAdventOfCode)
  private
    maxX, MaxY, PartA: Integer;
    Blizards: TDictionary<TPoint,rBlizard>;
    PlayerPosition, ExitPosition: TPoint;
    function FindPath(aFrom, aTo: TPoint; aTimePassed: integer): integer;
  protected
    procedure BeforeSolve; override;
    procedure AfterSolve; override;
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
{$REGION 'TAdventOfCodeDay10'}
procedure TAdventOfCodeDay10.BeforeSolve;
var
  Cycle, RegisterX, CurrentInstructionIndex: Integer;
  Split: TStringDynArray;
begin
  inherited;

  RegisterX := 1;
  Cycle := 0;
  CurrentInstructionIndex := 0;

  while Cycle < 240 do
  begin
    Inc(Cycle);
    Memory[Cycle] := RegisterX;

    Split := SplitString(FINput[CurrentInstructionIndex], ' ');
    inc(CurrentInstructionIndex);
    if Split[0] = 'addx' then
    begin
      Inc(Cycle);
      Memory[Cycle] := RegisterX;
      Inc(RegisterX, Split[1].ToInteger);
    end;
  end;
end;

function TAdventOfCodeDay10.SolveA: Variant;
var
  Cycle, i: Integer;
begin
  result := 0;
  for i := 0 to 5 do
  begin
    Cycle := 20 + 40 * i;
    Result := Result + Cycle * Memory[Cycle];
  end;
end;

function TAdventOfCodeDay10.SolveB: Variant;
var
  Reader: TAOCLetterReader_5_6;
begin
  Reader := TAOCLetterReader_5_6.Create;
  Result := Reader.ReadLetters(8,
    function(const aRowNo, aColumnNo: integer): boolean
    var
      RegisterX: Integer;
    begin
      RegisterX := Memory[aRowNo * 40 + aColumnNo + 1];
      Result := Abs(aColumnNo-RegisterX) <= 1;
    end);
    Reader.Free;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay11'}
type
  TMonkeyOperationPart = (Constant, OldValue);
  TMonkey = class
  strict private
    Items: TList<int64>;

    Operation: TMonkeyMathOperation;
    OperationPart: TMonkeyOperationPart;
    OperationConstant: int64;

    FId, FIdTrueMonkey, FIdFalseMonkey: Integer;
    FDivisor, FItemsInspected: Int64;
  public
    Constructor CreateFromStrings(aStrings: TStrings; aOffset: Integer);
    Destructor Destroy; override;

    procedure InspectItems(MonkeyTrue, MonkeyFalse: TMonkey; PartB: boolean; lcm: int64);
    procedure AddItem(const aItem: int64);

    property Id: integer read FId;
    property IdTrueMonkey: integer read FIdTrueMonkey;
    property IdFalseMonkey: integer read FIdFalseMonkey;
    property Divisor: Int64 read FDivisor;
    property ItemsInspected: Int64 Read FItemsInspected;
end;

constructor TMonkey.CreateFromStrings(aStrings: TStrings; aOffset: Integer);
var
  Split: TStringDynArray;
  i: integer;
begin
  // Init
  items := TList<int64>.Create;
  FItemsInspected := 0;

  // Id
  Split := SplitString(aStrings[aOffset], ':');
  Split := SplitString(Split[0], ' ');
  FId := StrToInt(Split[1]);

  // Items
  Split := SplitString(aStrings[aOffset+1], ':');
  Split := SplitString(Split[1], ',');
  for i := 0 to Length(Split)-1 do
    items.Add(StrToInt64(split[i]));

  // Operation
  Split := SplitString(trim(aStrings[aOffset+2]), ' ');
  Operation := Add;
  if Split[4] = '*' then
    Operation := Multiply;

  OperationPart := OldValue;
  if TryStrToInt64(Split[5], OperationConstant) then
    OperationPart := Constant;

  // Test
  Split := SplitString(trim(aStrings[aOffset+3]), ' ');
  FDivisor := StrToInt64(Split[3]);

  // If true
  Split := SplitString(trim(aStrings[aOffset+4]), ' ');
  FIdTrueMonkey := StrToInt(Split[5]);

  // If false
  Split := SplitString(trim(aStrings[aOffset+5]), ' ');
  FIdFalseMonkey := StrToInt(Split[5]);
end;

destructor TMonkey.Destroy;
begin
  Items.Free;
  inherited;
end;

procedure TMonkey.AddItem(const aItem: int64);
begin
  Items.Add(aItem);
end;

procedure TMonkey.InspectItems(MonkeyTrue, MonkeyFalse: TMonkey; PartB: boolean; lcm: int64);
var
  Item, OperationValue: Int64;
begin
  Inc(FItemsInspected, Items.Count);

  while items.Count > 0 do
  begin
    Item := items.ExtractAt(0);
    OperationValue := Item;
    if OperationPart = Constant then
      OperationValue := OperationConstant;

    case Operation of
      Add: Item := Item + OperationValue;
      Multiply: Item := Item * OperationValue;
    end;

    if PartB then
      item := Item mod lcm
    else
      Item := trunc(Item / 3);

    if Item mod Divisor = 0  then
      MonkeyTrue.AddItem(Item)
    else
      MonkeyFalse.AddItem(Item);
  end;
end;

function TAdventOfCodeDay11.SolveA: Variant;
begin
  Result := ChaseMonkeys(False);
end;

function TAdventOfCodeDay11.SolveB: Variant;
begin
  Result := ChaseMonkeys(True);
end;

function TAdventOfCodeDay11.ChaseMonkeys(PartB: boolean): int64;
var
  MonkeyCount, MonkeyIndex, Round: Integer;
  Lcm, Max1, Max2: Int64;
  Monkey: TMonkey;
  Monkeys: Array of TMonkey;
begin
  MonkeyCount := (FInput.Count+1) div 7;

  SetLength(Monkeys, MonkeyCount);
  Lcm := 1;
  for MonkeyIndex := 0 to MonkeyCount-1 do
  begin
    Monkey := TMonkey.CreateFromStrings(FInput, MonkeyIndex*7);
    Lcm := Lcm * Monkey.Divisor;
    Monkeys[Monkey.Id] := Monkey;
  end;

  for round := 1 to IfThen(PartB, 10000, 20) do
    for MonkeyIndex := 0 to MonkeyCount -1 do
    begin
      Monkey := Monkeys[MonkeyIndex];
      Monkey.InspectItems(Monkeys[Monkey.IdTrueMonkey], Monkeys[Monkey.IdFalseMonkey], PartB, lcm);
    end;

  Max1 := 0;
  for MonkeyIndex := 0 to MonkeyCount -1 do
    Max1 := Max(Monkeys[MonkeyIndex].ItemsInspected, Max1);

  Max2 := 0;
  for MonkeyIndex := 0 to MonkeyCount -1 do
    if Monkeys[MonkeyIndex].ItemsInspected <> Max1 then
    Max2 := Max(Monkeys[MonkeyIndex].ItemsInspected, Max2);

  Result := Max1 * Max2;

  for MonkeyIndex := 0 to MonkeyCount -1 do
    Monkeys[MonkeyIndex].Free;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay12'}
procedure TAdventOfCodeDay12.BeforeSolve;
var
  c: Char;
  x,y: integer;
  point: TPoint;
begin
  inherited;

  MaxX := Length(FInput[0]) - 1;
  MaxY := FInput.Count - 1;
  Points_a := BlankBitGrid;

  SetLength(Heights, MaxX+1);
  for x := 0 to MaxX do
    SetLength(Heights[x], MaxY +1);

  for y := 0 to MaxY  do
    for x := 0 to MaxX do
    begin
      c := FInput[y][x+1];
      point := TPoint.Create(x, y);
      if c = 'S' then
      begin
        c := 'a';
        PointS := point;
      end
      else if c = 'E' then
      begin
        c := 'z';
        PointE := point;
      end;

      Points_a[x][y] := c = 'a';
      Heights[x][y] := ord(c) - Ord('a');
    end;
end;

function TAdventOfCodeDay12.BlankBitGrid: TBitGrid;
var
  x,y: integer;
begin
  SetLength(Result, MaxX+1);
  for x := 0 to MaxX do
  begin
    SetLength(Result[x], MaxY +1);
    for y := 0 to MaxY do
      Result[x][y] := False;
  end
end;

type rWork = record
  Steps: integer;
  point: TPoint;
end;

function TAdventOfCodeDay12.SolveA: Variant;
var
  Targets: TBitGrid;
begin
  Targets := BlankBitGrid;
  Targets[PointE.x][PointE.y] := true;
  Result := FindPath(PointS, Targets, True);
end;

function TAdventOfCodeDay12.SolveB: Variant;
begin
  Result := FindPath(PointE, Points_a, False);
end;

function TAdventOfCodeDay12.FindPath(aFrom: TPoint; aTo: TBitGrid; IsUphill: boolean): Integer;
var
  CurrHeight, TargetHeight, i: Integer;
  Work, NewWork: rWork;
  Seen: TBitGrid;
  Comparer: IComparer<rWork>;
  Queue: PriorityQueue<rWork>;
  CanReach: Boolean;
begin
  Result := -1;
  Comparer := TComparer<rWork>.Construct(
    function(const Left, Right: rWork): integer
    begin
      Result := Sign(Left.Steps - Right.Steps);
    end);

  Queue := PriorityQueue<rWork>.Create(Comparer, Comparer);
  Seen := BlankBitGrid;

  Work.Steps := 0;
  Work.point := aFrom;
  Queue.Enqueue(Work);

  while Queue.Count > 0 do
  begin
    work := Queue.Dequeue;

    if aTo[work.point.x][work.point.y] then
      exit(work.Steps);

    if Seen[work.point.x][work.point.y] then
      continue;
    Seen[work.point.x][work.point.y] := True;

    CurrHeight := Heights[Work.point.x][Work.point.y];

    for i := 0 to 3 do
    begin
      NewWork := Work;
      NewWork.Steps := Work.Steps + 1;
      NewWork.point.Offset(DeltaX[i], DeltaY[i]);

      if (InRange(NewWork.point.x, 0, MaxX) and InRange(NewWork.point.y, 0, MaxY))  then
      begin
        TargetHeight := Heights[NewWork.point.X, NewWork.point.Y];

        if IsUphill then
          CanReach := TargetHeight <= CurrHeight + 1
        else
          CanReach := CurrHeight <= TargetHeight + 1;

        if CanReach then
          Queue.Enqueue(NewWork);
      end;
    end;
  end;
end;

{$ENDREGION}
{$REGION 'TAdventOfCodeDay13'}
function TPacketComparer.Compare(const Left, Right: TJsonValue): Integer;

  function _ToArray(aValue: TJsonValue): TJSONArray;
  begin
    if (aValue is TJSONArray) then
      Result := TJSONArray(aValue)
    else
      Result := TJSONArray.Create.Add(TJSONNumber(aValue).AsInt);
  end;

var
  i: Integer;
  arrayLeft, arrayRight: TJSONArray;
begin
  if (Left is TJSONNumber) and (Right is TJSONNumber) then
    Exit(Sign(TJSONNumber(Left).AsInt - TJSONNumber(Right).AsInt));

  arrayLeft := _ToArray(Left);
  arrayRight := _ToArray(Right);
  try
    for i := 0 to Min(arrayLeft.Count, arrayRight.Count)-1 do
    begin
      Result := Compare(arrayLeft.Items[i], arrayRight.Items[i]);
      if Result <> 0 then
        Exit;
    end;

    Result := Sign(arrayLeft.Count - arrayRight.Count);
  finally
    if Left is TJsonNumber then
      arrayLeft.Free;
    if Right is TJsonNumber then
      arrayRight.Free;
  end;
end;

procedure TAdventOfCodeDay13.BeforeSolve;
begin
  inherited;
  PacketComparer := TPacketComparer.Create;;
end;

procedure TAdventOfCodeDay13.AfterSolve;
begin
  PacketComparer.Free;
  inherited;
end;

function TAdventOfCodeDay13.SolveA: Variant;
var
  i, index: Integer;
  Left, Right: TJSONValue;
begin
  Result := 0;

  i := 0;
  index := 1;
  while i < FInput.Count-1 do
  begin
    Left := TJSONObject.ParseJSONValue(FInput[i]);
    Right := TJSONObject.ParseJSONValue(FInput[i+1]);

    if PacketComparer.Compare(Left, Right) < 0 then
      Inc(Result, Index);

    Left.Free;
    Right.Free;

    inc(index);
    Inc(i, 3);
  end;
end;

function TAdventOfCodeDay13.SolveB: Variant;
var
  i: Integer;
  s: String;
  Values: TObjectList<TJSONValue>;
begin
  Values := TObjectList<TJSONValue>.Create(True);

  for s in FInput do
    if s <> '' then
      Values.Add(TJSONObject.ParseJSONValue(s));

  Values.Add(TJSONObject.ParseJSONValue('[[2]]'));
  Values.Add(TJSONObject.ParseJSONValue('[[6]]'));

  Values.Sort(PacketComparer);

  Result := 1;
  for i := 0 to Values.Count -1 do
  begin
    s := Values[i].ToJSON;
    if (s = '[[2]]') or (s = '[[6]]') then
      Result := Result * (i+1);
  end;
  Values.Free;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay14'}
function TAdventOfCodeDay14.SolveA: Variant;
begin
  Result := FillCave(false);
end;

function TAdventOfCodeDay14.SolveB: Variant;
begin
  Result := FillCave(True);
end;

function TAdventOfCodeDay14.FillCave(PartB: Boolean): integer;
const
  DeltaX: array[0..2] of integer = (0, -1, 1);
var
  i: Integer;
  s: String;
  Split: TStringDynArray;
  Grid: Array[0..1000] of Array[0..1000] of Boolean;
  x, xFrom, xTo, y, yFrom, yTo, MaxY, SandX, SandY, WallCount : Integer;
  CanMoveDown: Boolean;

  function _countBlocked: integer;
  var
    x, y: Integer;
  begin
    Result := 0;
    for x := 0 to 1000 do
      for y := 0 to MaxY + 1 do
        if Grid[x][y] then
          Inc(Result);
  end;

begin
  for x := 0 to 1000 do
    for y := 0 to 1000 do
      Grid[x][y] := False;

  MaxY := 0;
  for s in FInput do
  begin
    Split := SplitString(StringReplace(s, ' -> ', ',', [rfReplaceAll]), ',');

    xFrom := split[0].ToInteger();
    yFrom := split[1].ToInteger();

    i := 2;
    while i < Length(Split)-1 do
    begin
      xTo := split[i].ToInteger();
      yTo := split[i + 1].ToInteger();

      MaxY := Max(MaxY, yTo);
      MaxY := Max(MaxY, yFrom);
      for x := Min(xFrom, xTo) to Max(xFrom, xTo) do
        for y := Min(yFrom, yTo) to Max(yFrom, yTo) do
          Grid[x][y] := True;

      xFrom := xTo;
      yFrom := yTo;
      Inc(i, 2);
    end;
  end;

  WallCount := _countBlocked;

  while True do
  begin
    SandX := 500;
    SandY := 0;

    CanMoveDown := True;
    while CanMoveDown do
    begin
      if (SandY = MaxY + 2 )then
        Break;

      CanMoveDown := False;
      for i := 0 to 2 do
        if not Grid[SandX + DeltaX[i]][SandY+1] then
        begin
          Inc(SandX, DeltaX[i]);
          inc(SandY, 1);
          CanMoveDown := True;
          Break;
        end;
    end;

    if (not CanMoveDown) or PartB then
      Grid[SandX][SandY] := True;

    if Grid[500][0] or (CanMoveDown and not partB) then
      Break;
  end;

  Result := _countBlocked - WallCount;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay15'}
class function TSensorData.LoadFromString(aStr: string): TSensorData;
var
  Split: TStringDynArray;
begin
  aStr := StringReplace(aStr, ':', '', [rfReplaceAll]);
  Split := SplitString(aStr, ' =,');

  Result.SensorX := StrToInt64(Split[3]);
  Result.SensorY := StrToInt64(Split[6]);
  Result.BeaconX := StrToInt64(Split[12]);
  Result.BeaconY := StrToInt64(Split[15]);
  Result.ScanDistance := Abs(Result.SensorX - Result.BeaconX) + Abs(Result.SensorY - Result.BeaconY);
end;

procedure TAdventOfCodeDay15.BeforeSolve;
var
  s: string;
begin
  inherited;

  FScan := TList<TSensorData>.Create;
  for s in FInput do
    FScan.Add(TSensorData.LoadFromString(s));
end;

procedure TAdventOfCodeDay15.AfterSolve;
begin
  inherited;
  FScan.Free;
end;

type
  rRange = record
    Left, Right: int64;
  end;

function TAdventOfCodeDay15.SolveA: Variant;
const TargetLine: int64 = 2000000;
var
  i: Integer;
  HDistance: int64;
  NewRange, Range: rRange;
  Ranges: TList<rRange>;
  CanAdd: Boolean;
  Sensor: TSensorData;
  BeaconsOnLine: TList<int64>;
begin
  BeaconsOnLine := TList<int64>.Create;
  Ranges := TList<rRange>.Create;

  for Sensor in FScan do
  begin
    HDistance := Sensor.ScanDistance - Abs(Sensor.SensorY-TargetLine);

    if HDistance < 0 then
      Continue;

    NewRange.Left := Sensor.SensorX - HDistance;
    NewRange.Right := Sensor.SensorX + HDistance;

    // Check if the new range falls completly in a registerd range
    CanAdd := True;
    for Range in Ranges do
      if InRange(NewRange.Left, Range.Left, Range.Right) then
        if InRange(NewRange.Right, Range.Left, Range.Right) then
          CanAdd := False;

    if not CanAdd then
      Continue;

    // Check if there is an existing range in the new range, ifso delete the old range
    for i := Ranges.Count - 1 downto 0 do
    begin
      Range := Ranges[i];
      if InRange(Range.Left, NewRange.Left, NewRange.Right) then
        if InRange(Range.Right, NewRange.Left, NewRange.Right) then
          Ranges.Delete(i);
    end;

    // Fix overlap
    for i := Ranges.Count-1 downto 0 do
    begin
      Range := Ranges[i];
      if InRange(NewRange.Left, Range.Left, Range.Right) then
      begin
        Range.Right := NewRange.Left -1;
        Ranges.Delete(i);
        Ranges.Add(Range)
      end
      else if InRange(NewRange.Right, Range.Left, Range.Right) then
      begin
        Range.Left := NewRange.Right +1;
        Ranges.Delete(i);
        Ranges.Add(Range)
      end;
    end;

    Ranges.Add(NewRange);
    if (Sensor.BeaconY = TargetLine) and not BeaconsOnLine.Contains(Sensor.BeaconX) then
      BeaconsOnLine.Add(Sensor.BeaconX);
  end;

  Result := -BeaconsOnLine.Count;;
  for Range in Ranges do
    Result := Result + Range.Right - Range.Left + 1;

  BeaconsOnLine.Free;
  Ranges.Free;
end;

type LineSegment = record
  Top, Bottom: TPosition;
  class function Create(aTop, aBottom: TPosition): LineSegment; static;
end;

class function LineSegment.Create(aTop, aBottom: TPosition): LineSegment;
begin
  Result.Top := aTop;
  Result.Bottom := ABottom
end;

function TAdventOfCodeDay15.SolveB: Variant;

  function _Between(value, a,b: int64): boolean;
  var
    aMin, aMax: int64;
  begin
    aMin := Min(a,b);
    aMax := Max(a,b);
    Result := InRange(value, aMin, aMax);
  end;

  procedure MergeSegments(aSegments: TList<LineSegment>; Direction: int64);
  var
    TempSegments: TList<LineSegment>;
    i,j: integer;
    BaseX1, BaseX2: int64;
    Seg1, Seg2, NewSegment: LineSegment;
  begin
    TempSegments := TList<LineSegment>.Create(aSegments);
    aSegments.Clear;
    for i := 0 to TempSegments.Count-1 do
      for j := i+1 to TempSegments.Count-1 do
      begin
        Seg1 := TempSegments[i];
        Seg2 := TempSegments[j];

        BaseX1 := Seg1.Bottom.x - Seg1.Bottom.y * Direction;
        BaseX2 := Seg2.Bottom.x - Seg2.Bottom.y * Direction;

        if BaseX1 <> BaseX2 then
          Continue;

        NewSegment.Top := Seg1.Top;
        if Seg1.top.x > Seg2.top.x then
          NewSegment.Top := Seg2.Top;

        NewSegment.Bottom := Seg1.Bottom;
        if Seg1.Bottom.x < Seg2.Bottom.x then
          NewSegment.Bottom := Seg2.Bottom;

        if NewSegment.Top.y > NewSegment.Bottom.y then
          aSegments.Add(NewSegment);
      end;
    TempSegments.Free;
  end;

var
  x, y, d, b1, b2: Int64;
  pTop, pLeft, pRight, pBottom: TPosition;
  pSegment, nSegment: LineSegment;
  Data: TSensorData;
  Valid: Boolean;
  pLines, nLines: TList<LineSegment>;
begin
  pLines := TList<LineSegment>.Create;
  nLines := TList<LineSegment>.Create;

  try
    for Data in FScan do
    begin
      d := Data.ScanDistance +1;

      pTop    := pTop.SetIt(Data.SensorX, Data.SensorY + d);
      pLeft   := pLeft.SetIt(Data.SensorX - d, Data.SensorY);
      pRight  := pRight.SetIt(Data.SensorX + d, Data.SensorY);
      pBottom := pBottom.SetIt(Data.SensorX, Data.SensorY - d);

      pLines.Add(LineSegment.Create(pTop, pLeft));
      pLines.Add(LineSegment.Create(pRight, pBottom));
      nLines.Add(LineSegment.Create(pTop, pRight));
      nLines.Add(LineSegment.Create(pLeft, pBottom));
    end;

    MergeSegments(pLines, 1);
    MergeSegments(nLines, -1);

    for pSegment in pLines do
      for nSegment in nLines do
      begin
        b1 := pSegment.Top.Y - pSegment.Top.X;
        b2 := nSegment.Top.Y + nSegment.Top.X;

        x := round((b2 - b1) / 2);
        y := x + b1;
        if _Between(x, pSegment.Bottom.x, pSegment.Top.x) and
           _Between(x, nSegment.Bottom.x, nSegment.Top.x) and
           _Between(y, pSegment.Bottom.y, pSegment.Top.y) and
           _Between(y, nSegment.Bottom.y, nSegment.Top.y) and
           InRange(x, 0, 4000000) and InRange(y, 0, 4000000) then
        begin

          Valid := True;
          for Data in FScan do
            if (abs(x - Data.SensorX) + abs(Y - Data.SensorY)) < Data.ScanDistance then
              Valid := False;

          if Valid then
            Exit(x*4000000+y);
        end;
      end;
  finally
    nLines.Free;
    pLines.Free;
  end;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay16'}
class function rValveData.LoadFromString(GlobalId: Byte; aStr: string): rValveData;
var
  i: Integer;
  Split: TStringDynArray;
begin
  aStr := aStr.Replace(';', '').Replace(',', '').Replace('=', ' ');
  Split := SplitString(aStr, ' ');

  Result.GlobalId := GlobalId;
  Result.Name := Split[1];
  Result.FlowRate := Split[5].ToInteger;
  SetLength(Result.ConnectedTo, Length(Split) -10);
  for i := 10 to Length(Split) -1 do
    Result.ConnectedTo[i-10] := Split[i];
end;

class function rValveState.create(aOpenValves: SetOfByte; aTotalFlow: Integer): rValveState;
begin
  Result.OpenValves := aOpenValves;
  Result.TotalFlow := aTotalFlow;
end;

procedure TAdventOfCodeDay16.BeforeSolve;

  type ValveWork = record
    Valve: rValveData;
    Distance: integer;
  end;

  function _CalcDistance(aFrom, aTo: rValveData): integer;
  var
    Comparer: IComparer<ValveWork>;
    Queue: PriorityQueue<ValveWork>;
    CurrentWork, NewWork: ValveWork;
    s: string;
    Seen: SetOfByte;
  begin
    Seen := [];
    Comparer := TComparer<ValveWork>.Construct(
      function(const Left, Right: ValveWork): integer
      begin
        result := Sign(Left.Distance - Right.Distance);
      end);
    Queue := PriorityQueue<ValveWork>.Create(Comparer, Comparer);

    NewWork.Distance := 0;
    NewWork.Valve := aFrom;
    Queue.Enqueue(NewWork);

    while queue.Count > 0 do
    begin
      CurrentWork := Queue.Dequeue;
      if CurrentWork.Valve.GlobalId = aTo.GlobalId then
        Exit(CurrentWork.Distance);

      if CurrentWork.Valve.GlobalId in seen then
        Continue;
      Include(Seen, CurrentWork.Valve.GlobalId);

      for s in CurrentWork.Valve.ConnectedTo do
      begin
        NewWork.Distance := CurrentWork.Distance + 1;
        NewWork.Valve := AllValves[s];
        Queue.Enqueue(NewWork);
      end;
    end;

    raise Exception.CreateFmt('No path between %s and %s', [aFrom.Name, aTo.Name]);
  end;

var
  s: String;
  Valve: rValveData;
  i,j,Distance: integer;
  PartBComparer : IComparer<rValveState>;
begin
  inherited;

  AllValves := TDictionary<string, rValveData>.Create;
  InteresstingValves := TList<rValveData>.Create;

  // Read input
  for s in FInput do
  begin
    Valve := rValveData.LoadFromString(AllValves.Count, s);
    Valve.Id := 255;
    if (Valve.FlowRate > 0) or (Valve.Name = 'AA') then
    begin
      Valve.Id := InteresstingValves.Count;
      InteresstingValves.Add(Valve);
    end;

    AllValves.Add(Valve.Name, Valve);
  end;

  ValveAA := AllValves['AA'].Id;

  // Build distance matrix for interesting valves
  SetLength(DistanceMatrix, InteresstingValves.Count);
  for i := 0 to InteresstingValves.Count-1 do
    SetLength(DistanceMatrix[i], InteresstingValves.Count);

  for i := 0 to InteresstingValves.Count-1 do
    for j := i+1 to InteresstingValves.Count-1 do
    begin
      Distance := _CalcDistance(InteresstingValves[i], InteresstingValves[j]);
      DistanceMatrix[i][j] := Distance;
      DistanceMatrix[j][i] := Distance;
    end;

  // Init stuff for part b, so it can be used in the calc loops of parta
  PartBComparer := TComparer<rValveState>.Construct(
    function(const Left, Right: rValveState): integer
    begin
      Result := Sign(Right.TotalFlow - Left.TotalFlow);
    end);
  PartBData := PriorityQueue<rValveState>.Create(PartBComparer,PartBComparer);
end;

procedure TAdventOfCodeDay16.AfterSolve;
begin
  inherited;
  AllValves.Free;
  InteresstingValves.Free;
end;

function TAdventOfCodeDay16.SolveA: Variant;

  function DoOpenValves(Current: Byte; ScoreA, TimeLeftA, ScoreB, TimeLeftB: integer; OpenValves: SetOfByte): int64;
  var
    LocalTimeA, FlowA, LocalTimeB, FlowB: integer;
    NextId: Byte;
  begin
    Result := ScoreA;
    if TimeLeftA <= 1 then
      Exit;

    if TimeLeftB >= 1 then
      PartBData.Enqueue(rValveState.create(OpenValves, ScoreB));

    for NextId := 0 to InteresstingValves.Count-1 do
    begin
      if not (NextId in OpenValves) then
      begin
        LocalTimeA := TimeLeftA -1 - DistanceMatrix[Current][NextId];
        FlowA := LocalTimeA*InteresstingValves[NextId].FlowRate;
        LocalTimeB := TimeLeftB -1 - DistanceMatrix[Current][NextId];
        FlowB := LocalTimeB*InteresstingValves[NextId].FlowRate;

        Result := Max(Result, DoOpenValves(NextId, ScoreA + FlowA, LocalTimeA, ScoreB + FlowB, LocalTimeB, OpenValves + [NextId]))
      end;
    end;
  end;

begin
  Result := DoOpenValves(ValveAA, 0, 30, 0, 26, [ValveAA]);
end;

function TAdventOfCodeDay16.SolveB: Variant;
var
  i: Integer;
  CurrentState: rValveState;
  All: TArray<rValveState>;
begin
  result := 0;

  All := PartBData.Elements.ToArray;
  while PartBData.Count > 0 do
  begin
    CurrentState := PartBData.Dequeue;

    for i := 0 to PartBData.Count-1 do
    begin
      if (Result > 0) and (CurrentState.TotalFlow + All[i].TotalFlow < Result) then
        Break;

      if CurrentState.OpenValves*All[i].OpenValves = [ValveAA] then
        Result := Max(Result, CurrentState.TotalFlow + All[i].TotalFlow);
    end;
  end;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay17'}
const Rocks: Array[0..4] of array[0..4] of  TPoint =
(
  ((X:0; Y:0),(X:1; Y:0),(X:2; Y:0),(X:3; Y:0),(X:3; Y:0)),
  ((X:1; Y:0),(X:0; Y:1),(X:1; Y:1),(X:2; Y:1),(X:1; Y:2)),
  ((X:0; Y:0),(X:1; Y:0),(X:2; Y:0),(X:2; Y:1),(X:2; Y:2)),
  ((X:0; Y:0),(X:0; Y:1),(X:0; Y:2),(X:0; Y:3),(X:0; Y:3)),
  ((X:0; Y:0),(X:1; Y:0),(X:0; Y:1),(X:1; Y:1),(X:1; Y:1))
);

procedure TAdventOfCodeDay17.BeforeSolve;
var
  RockPixels: TDictionary<TPoint,Boolean>;

  function _ValidPosition(X, Y, RockIndex: integer): boolean;
  var
    RockOffsets, Point: TPoint;
  begin
    Result := True;
    for RockOffsets in Rocks[RockIndex] do
    begin
      Point := TPoint.Create(x,y);
      Point.Offset(RockOffsets);

      if (Point.X < 0) or (Point.X > 6) or (Point.Y < 0) then
        Exit(False);

      if RockPixels.ContainsKey(Point) then
        Exit(False);
    end;
  end;


var
  Seen: TDictionary<integer, int64>;
  Heights: TList<int64>;
  BaseX, RockIndex, instructionIndex, Key: integer;
  DeltaX, BaseY, Counter, MaxHeight: Int64;
  Start, PrevCounter, CounterDelta, DeltaSteps, HeightDelta, StepsLeft, StepsRemainder: int64;
  RockPixel, RockOffSet: TPoint;
begin
  inherited;

  Seen := TDictionary<integer, int64>.Create;
  Heights := TList<int64>.Create;
  RockPixels := TDictionary<TPoint, boolean>.Create;
  try
    Heights.Add(0);

    instructionIndex := 0;
    RockIndex := -1;
    MaxHeight := 0;
    Counter := 0;
    while Counter < 1000000000000 do
    begin
      Inc(Counter);
      BaseX := 2;
      BaseY := Heights.Last + 3;
      RockIndex := (RockIndex + 1) mod 5;

      while true do
      begin
        // Move instructionPointer
        instructionIndex := instructionIndex + 1;
        if instructionIndex > Length(FInput[0]) then
          instructionIndex := 1;

        // Deterimine direction
        DeltaX := 1;
        if FInput[0][instructionIndex] = '<' then
          DeltaX := -1;

        // Check if the rock can move horizontal;
        if _ValidPosition(BaseX + DeltaX, BaseY, RockIndex) then
          BaseX := BaseX + DeltaX;

        // Try to move rock down
        BaseY := BaseY - 1;
        if not _ValidPosition(BaseX, BaseY, RockIndex) then
        begin
          // At this point the rock stopped moving, revert change in y-direction
          BaseY := BaseY + 1;

          // Mark all points of the rock as visited
          for RockOffSet in Rocks[RockIndex] do
          begin
            RockPixel := TPoint.Create(BaseX, BaseY);
            RockPixel.Offset(RockOffSet);
            if not RockPixels.ContainsKey(RockPixel) then
              RockPixels.Add(RockPixel, True);
            MaxHeight := Max(MaxHeight, RockPixel.Y + 1);
          end;

          // Try to find a patern after a warmup
          if (Counter > 2022) then
          begin
            Key := (RockIndex shl 28) + (BaseX shl 24) + instructionIndex;

            if Seen.TryGetValue(Key, PrevCounter) then
            begin
              CounterDelta := Counter - PrevCounter;
              HeightDelta := MaxHeight - Heights[Counter-CounterDelta];

              StepsLeft := 1000000000000 - Counter;

              DeltaSteps := StepsLeft div CounterDelta;
              StepsRemainder := StepsLeft mod CounterDelta;
              Start := Counter - CounterDelta + StepsRemainder;

              PartA := Heights[2022];
              PartB := Heights[Start] + (DeltaSteps + 1) * HeightDelta;

              Exit;
            end
            else
              Seen.Add(Key, Counter);
          end;

          Heights.Add(MaxHeight);
          break;
        end;
      end;
    end;
  finally
    Heights.Free;
    Seen.Free;
    RockPixels.Free;
  end;
end;

function TAdventOfCodeDay17.SolveA: Variant;
begin
  Result := PartA;
end;

function TAdventOfCodeDay17.SolveB: Variant;
begin
  Result := PartB;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay18'}
const LavaBlockOffsets: array[0..5] of TPosition3 = (
  (x: 1; y: 0; z: 0), (x: 0; y: 1; z: 0), (x: 0; y: 0; z: 1),
  (x:-1; y: 0; z: 0), (x: 0; y:-1; z: 0), (x: 0; y: 0; z:-1));

procedure TAdventOfCodeDay18.BeforeSolve;
var
  LavaBlocks, AirBlocks: TDictionary<TPosition3,Boolean>;
  AirBlocksToCalc: TStack<TPosition3>;
  LavaBlock, MinPos, MaxPos, PositionToCheck, Offset: TPosition3;
  s: string;
  Split: TStringDynArray;
begin
  PartA := 0;
  PartB := 0;

  inherited;

  LavaBlocks := TDictionary<TPosition3, Boolean>.Create;
  AirBlocks := TDictionary<TPosition3, Boolean>.Create;
  AirBlocksToCalc := TStack<TPosition3>.Create;
  try
    MinPos := TPosition3.Create(MaxInt, MaxInt, MaxInt);
    MaxPos := TPosition3.Create(-MaxInt, -MaxInt, -MaxInt);
    for s in FInput do
    begin
      Split := SplitString(s, ',');
      LavaBlock := TPosition3.Create(Split[0].ToInteger, Split[1].ToInteger, Split[2].ToInteger);
      LavaBlocks.Add(LavaBlock, True);

      MinPos := TPosition3.Min(MinPos, LavaBlock);
      MaxPos := TPosition3.Max(MaxPos, LavaBlock);
    end;

    MinPos := MinPos + TPosition3.Create(-1,-1,-1);
    MaxPos := MaxPos + TPosition3.Create(1,1,1);

    AirBlocksToCalc.Push(MinPos);
    while AirBlocksToCalc.Count > 0 do
    begin
      PositionToCheck := AirBlocksToCalc.Pop;
      if AirBlocks.ContainsKey(PositionToCheck) or LavaBlocks.ContainsKey(PositionToCheck) or (PositionToCheck < MinPos) or (PositionToCheck > MaxPos) then
        Continue;

      AirBlocks.Add(PositionToCheck, True);
      for Offset in LavaBlockOffsets do
        AirBlocksToCalc.Push(PositionToCheck + Offset);
    end;

    for LavaBlock in LavaBlocks.Keys do
      for Offset in LavaBlockOffsets do
      begin
        PositionToCheck := LavaBlock + Offset;
        if LavaBlocks.ContainsKey(PositionToCheck) then
          Continue;

        Inc(PartA);
        if AirBlocks.ContainsKey(PositionToCheck) then
          Inc(PartB);
      end;
  finally
    LavaBlocks.Free;
    AirBlocks.Free;
    AirBlocksToCalc.Free;
  end;
end;

function TAdventOfCodeDay18.SolveA: Variant;
begin
  Result := PartA;
end;

function TAdventOfCodeDay18.SolveB: Variant;
begin
  Result := PartB;
end;

{$ENDREGION}
{$REGION 'TAdventOfCodeDay19'}
class function rBlueprint.LoadFromString(aStr: string): rBlueprint;
var
  split: TStringDynArray;
  OreType1, OreType2: TOreType;
begin
  Split := SplitString(aStr.Replace(':', ''), ' ');
  Result.BluePrintId := Split[1].ToInteger;

  for OreType1 := Low(TOreType) to High(TOreType) do
    for OreType2 := Low(TOreType) to High(TOreType) do
      Result.Costs[OreType1][OreType2] := 0;

  Result.Costs[ore][ore] := Split[6].ToInteger;
  Result.Costs[clay][ore] := Split[12].ToInteger;
  Result.Costs[obsidian][ore] := Split[18].ToInteger;
  Result.Costs[obsidian][clay] := Split[21].ToInteger;
  Result.Costs[geode][ore] := Split[27].ToInteger;
  Result.Costs[geode][obsidian] := Split[30].ToInteger;
end;

function TAdventOfCodeDay19.AnalyzeBlueprint(aBlueprint: rBlueprint; runtime: integer): integer;
var
  MaxRobotsNeeded: TOreArray;
  BestGeodeCount: integer;

  procedure InternalAnalyze3(aTimeLeft: integer; RobotCount, OreCounts: TOreArray);
  var
    BestGeodeGues, TimeToSkip, CurrentGeodeCount: integer;
    CanMakeBot, BotsExists: boolean;
    NewRobotCount, NewOreCount: TOreArray;
    RobotToMake, CurrentOre2: TOreType;
  begin
    CurrentGeodeCount := OreCounts[geode] + RobotCount[geode] * (aTimeLeft);

    if aTimeLeft <= 0 then exit;
      BestGeodeCount := Max(BestGeodeCount, CurrentGeodeCount);

    BestGeodeGues := CurrentGeodeCount + ceil((aTimeLeft * (aTimeLeft-1))/2);
    if BestGeodeGues <= BestGeodeCount then
      Exit;

    for RobotToMake := High(TOreType) downto low(TOreType) do
    begin
      BotsExists := True;
      TimeToSkip := 0;

      if RobotCount[RobotToMake] >= MaxRobotsNeeded[RobotToMake] then
        Continue;

      for CurrentOre2 := Low(TOreType) to High(TOreType) do
      begin
        if aBlueprint.Costs[RobotToMake][CurrentOre2] = 0 then
          Continue; // Ore not requierd;

        BotsExists := BotsExists and (RobotCount[CurrentOre2] > 0);
        if not BotsExists then
          Continue; // One of the requierd bots is not producec

        CanMakeBot := (OreCounts[CurrentOre2] >= aBlueprint.Costs[RobotToMake][CurrentOre2]);
        if not CanMakeBot then
          TimeToSkip := Max(TimeToSkip, Ceil((aBlueprint.Costs[RobotToMake][CurrentOre2]- OreCounts[CurrentOre2]) / RobotCount[CurrentOre2]  ))
      end;

      if not BotsExists then
        Continue;

      inc(TimeToSkip);
      NewRobotCount := RobotCount;
      NewRobotCount[RobotToMake] := NewRobotCount[RobotToMake] + 1;

      NewOreCount := OreCounts;
      for CurrentOre2 := Low(TOreType) to High(TOreType) do
        NewOreCount[CurrentOre2] := NewOreCount[CurrentOre2] + TimeToSkip*RobotCount[CurrentOre2] - aBlueprint.Costs[RobotToMake][CurrentOre2];

       InternalAnalyze3(aTimeLeft-TimeToSkip, NewRobotCount, NewOreCount);
    end;
  end;

var
  RobotCounts, OreCounts: TOreArray;
  Robot, OreType: TOreType;
  MaxNeeded: Integer;
begin
  for OreType := Low(TOreType) to High(TOreType) do
  begin
    RobotCounts[OreType] := 0;
    OreCounts[OreType] := 0;
    MaxNeeded := 0;
    for Robot := Low(TOreType) to High(TOreType) do
      MaxNeeded := Max(MaxNeeded, aBlueprint.Costs[Robot][OreType]);
    MaxRobotsNeeded[OreType] := MaxNeeded;
  end;

  RobotCounts[ore] := 1;
  MaxRobotsNeeded[geode] := MaxInt;

  BestGeodeCount := 0;
  InternalAnalyze3(runtime, RobotCounts, OreCounts);
  Result := BestGeodeCount;
end;

function TAdventOfCodeDay19.SolveA: Variant;
var
  Blueprint: rBlueprint;
  GeodeCount: Integer;
  s: string;
begin
  Result := 0;
  for s in FInput do
  begin
    Blueprint := rBlueprint.LoadFromString(s);
    GeodeCount := AnalyzeBlueprint(Blueprint, 24);
    result := Result + GeodeCount * Blueprint.BluePrintId;
  end;
end;

function TAdventOfCodeDay19.SolveB: Variant;
var
  Blueprint: rBlueprint;
  GeodeCount: Integer;
  s: string;
begin
  Result := 1;
  for s in FInput do
  begin
    Blueprint := rBlueprint.LoadFromString(s);
    if Blueprint.BluePrintId > 3 then
      Continue;
    GeodeCount := AnalyzeBlueprint(Blueprint, 32);
    result := Result * GeodeCount;
  end;
end;

{$ENDREGION}
{$REGION 'TAdventOfCodeDay20'}
type tGroveNode = class
  Prev, Next: TGroveNode;
  Value: int64;
  constructor Create(aValue: int64); reintroduce;
end;

constructor tGroveNode.Create(aValue: int64);
begin
  Value := aValue;
end;

function TAdventOfCodeDay20.DecryptMessage(const DecreptionKey, Rounds: int64): int64;
var
  i, Steps, round, x: int64;
  Nodes: TObjectDictionary<integer,tGroveNode>;
  PrevNode, CurrentNode, NodeToMove, NewNext, NewPrev, ZeroNode: tGroveNode;
begin
  Nodes := TObjectDictionary<integer,tGroveNode>.Create([doOwnsValues]);
  PrevNode := nil;
  ZeroNode := nil;
  CurrentNode := nil;

  for i := 0 to FInput.Count -1 do
  begin
    CurrentNode := tGroveNode.Create(FInput[i].ToInt64 * DecreptionKey);
    CurrentNode.Prev := PrevNode;

    if Assigned(prevNode) then
      PrevNode.Next := CurrentNode;
    PrevNode := CurrentNode;

    if CurrentNode.Value = 0 then
      ZeroNode := CurrentNode;

    Nodes.add(i, CurrentNode);
  end;

  Nodes[0].Prev := CurrentNode;
  CurrentNode.Next := Nodes[0];

  for round := 1 to rounds do
  begin
    for i := 0 to Nodes.Count -1 do
    begin
      NodeToMove := Nodes[i];

      NodeToMove.Next.Prev := NodeToMove.Prev;
      NodeToMove.Prev.Next := NodeToMove.Next;

      NewNext := NodeToMove.next;
      NewPrev := NodeToMove.Prev;

      Steps := abs(NodeToMove.Value);
      Steps := Steps mod (Nodes.Count-1);

      if NodeToMove.Value > 0 then
      begin
        for x := 1 to Steps  do
          NewNext := NewNext.Next;
        NewPrev := NewNext.Prev;
      end
      else
      begin
        for x := 1 to Steps do
          NewPrev := NewPrev.Prev;
        NewNext := NewPrev.next;
      end;

      // Insert node in chain
      NewPrev.next := NodeToMove;
      NewNext.Prev := NodeToMove;
      NodeToMove.next := NewNext;
      NodeToMove.Prev := NewPrev;
    end;
  end;

  Result := 0;
  CurrentNode := ZeroNode;
  begin
    for i := 1 to 3 do
    begin
      for x := 1 to 1000 do
        CurrentNode := CurrentNode.Next;

      Result := result + CurrentNode.Value;
    end;
  end;

  Nodes.Free;
end;

function TAdventOfCodeDay20.SolveA: Variant;
begin
  Result := DecryptMessage(1, 1);
end;

function TAdventOfCodeDay20.SolveB: Variant;
begin
  Result := DecryptMessage(811589153, 10);
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay21'}
class function RMonkeyFormula.Create(aPart1, aPart2: string; aOperator: TMonkeyMathOperation): RMonkeyFormula;
begin
  Result.part1 := aPart1;
  Result.part2 := aPart2;
  Result.operation := aOperator;
end;

procedure TAdventOfCodeDay21.BeforeSolve;
var
  s: string;
  split: TStringDynArray;
  op: TMonkeyMathOperation;
begin
  inherited;

  Formulas := TDictionary<string,RMonkeyFormula>.Create;
  KnownNumbers := TDictionary<string,int64>.Create;

  for s in FInput do
    begin
      Split := SplitString(s.Replace(':', ''), ' ');

      if Length(Split) = 2 then
        KnownNumbers.Add(Split[0], Split[1].ToInt64)
      else
      begin
        case IndexText(Split[2], ['+', '-', '*', '/']) of
          0: op := Add;
          1: op := Subtract;
          2: op := Multiply;
          3: op := Divide;
        else
          raise Exception.Createfmt('unkown operator %s', [split[2]]);
        end;

        Formulas.Add(Split[0], RMonkeyFormula.Create(Split[1], Split[3], op));
      end;
    end;
end;

function TAdventOfCodeDay21.CalcSimpleFormula(Val1, Val2: Int64; aOperator: TMonkeyMathOperation): int64;
begin
  Result := 0;
  case aOperator of
    Add: Result := Val1 + Val2;
    Subtract: Result := Val1 - Val2;
    Multiply: Result := Val1 * Val2;
    Divide: Result := Round(Val1 / Val2);
  end;
end;

procedure TAdventOfCodeDay21.AfterSolve;
begin
  inherited;
  Formulas.Free;
  KnownNumbers.Free;
end;

function TAdventOfCodeDay21.SolveA: Variant;
var
  Val1, Val2, Res: Int64;
  FomulaPair: TPair<string, RMonkeyFormula>;
  known: TDictionary<string,int64>;
begin
  result := 0;
  known := TDictionary<string,int64>.Create(KnownNumbers);

  while true do
  begin
    for FomulaPair in Formulas do
    begin
      if known.ContainsKey(FomulaPair.Key) then
        Continue;

      if not (known.TryGetValue(FomulaPair.Value.part1, Val1) and known.TryGetValue(FomulaPair.Value.part2, Val2)) then
        Continue;

      Res := CalcSimpleFormula(Val1, Val2, FomulaPair.Value.operation);
      known.Add(FomulaPair.Key, Res);
      if FomulaPair.Key = 'root' then
        Exit(res);
    end;
  end;
end;

function TAdventOfCodeDay21.SolveB: Variant;
var
  FomulaPair: TPair<string, RMonkeyFormula>;
  Formula: RMonkeyFormula;
  Val1, Val2, Res, ToCalc: Int64;
  CalcFrom: String;
  known: TDictionary<string,int64>;
  DidCalc: boolean;
begin
  known := TDictionary<string,int64>.Create(KnownNumbers);
  known.Remove('humn');

  DidCalc := True;
  while DidCalc do
  begin
    DidCalc := False;
    for FomulaPair in Formulas do
    begin
      if known.ContainsKey(FomulaPair.Key) then
        Continue;

      if not (known.TryGetValue(FomulaPair.Value.part1, Val1) and known.TryGetValue(FomulaPair.Value.part2, Val2)) then
        Continue;

      Res := CalcSimpleFormula(Val1, Val2, FomulaPair.Value.operation);
      known.Add(FomulaPair.Key, Res);
      DidCalc := True;
    end;
  end;

  Formula := Formulas['root'];
  if known.TryGetValue(Formula.part1, ToCalc) then
    CalcFrom := Formula.Part2
  else if known.TryGetValue(Formula.part2, ToCalc) then
    CalcFrom := Formula.part1;

  while CalcFrom <> 'humn'  do
  begin
    Formula := Formulas[CalcFrom];

    if not known.TryGetValue(Formula.part1, Val1) then
    begin
      Val2 := Known[Formula.part2];
      case Formula.operation of
        Add: ToCalc := ToCalc - Val2;
        Subtract: ToCalc := ToCalc + Val2;
        Multiply: ToCalc := Round(ToCalc/Val2);
        Divide: ToCalc := ToCalc * Val2;
      end;
      known.Add(CalcFrom, ToCalc);
      CalcFrom := Formula.part1;
    end
    else
    if not known.TryGetValue(Formula.part2, Val2) then
    begin
      Val1 := Known[Formula.part1];
      case Formula.operation of
        Add: ToCalc := ToCalc - Val1;
        Subtract: ToCalc := Val1 - ToCalc;
        Multiply: ToCalc := Round(ToCalc/Val1);
        Divide: ToCalc := Round(Val1/ToCalc);
      end;

      known.Add(CalcFrom, ToCalc);
      CalcFrom := Formula.part2;
    end
  end;

  Result := ToCalc;
end;

{$ENDREGION}
{$REGION 'TAdventOfCodeDay22'}
function TAdventOfCodeDay22.SolveA: Variant;
var
  i, x,y: Integer;
  s: String;
  Split: TStringDynArray;
  PlayerPosition, NewPoint: TPosition;
  Val: Boolean;
  Grid: TDictionary<TPosition, boolean>;
  Facing, tmpDirection: uAOCUtils.TDirection;
begin
  PlayerPosition := PlayerPosition.SetIt(0,0);
  Grid := TDictionary<TPosition, boolean>.Create;
  for y := 0 to FInput.Count -3 do
    for x := 1 to Length(FInput[y]) do
    begin
      if FInput[y][x] = ' ' then
        Continue;
      NewPoint := NewPoint.SetIt(x, y+1);
      Grid.Add(NewPoint, FInput[y][x] = '.');

      if PlayerPosition.x = 0 then
        PlayerPosition := NewPoint;
    end;

  s := FInput[FInput.Count-1];
  s := s.Replace('L', '|L|', [rfReplaceAll]).Replace('R', '|R|', [rfReplaceAll]);
  Split := SplitString(s, '|');

  Facing := Right;
  for s in Split do
  begin
    if s = 'R' then
    begin
      Facing := uAOCUtils.TDirection((Ord(Facing)+1) mod 4);
      Continue;
    end
    else if s = 'L' then
    begin
      Facing := uAOCUtils.TDirection((Ord(Facing)+3) mod 4);
      Continue;
    end;

    for i := 1 to StrToInt(s) do
    begin
      NewPoint := PlayerPosition.Clone.ApplyDirection(Facing);
      if not Grid.ContainsKey(NewPoint) then
      begin
        tmpDirection := uAOCUtils.TDirection((Ord(Facing)+2) mod 4);
        NewPoint := PlayerPosition.Clone;
        while Grid.ContainsKey(NewPoint.Clone.ApplyDirection(tmpDirection)) do
          NewPoint := NewPoint.ApplyDirection(tmpDirection);
      end;

      if Grid.TryGetValue(NewPoint, Val) then
      begin
        if Val then
          PlayerPosition := NewPoint
        else
          break;
      end
    end;
  end;

  Result := 1000 * PlayerPosition.Y + 4 * PlayerPosition.X +  Ord(Facing);
  Grid.Free;
end;

type
  rWrapRule = Record
    X, Y: integer; // Topleft coord of current block
    CurrentFacing, NewFacing: uAOCUtils.TDirection; // CurrentFacing + NewFacing
    X_Const, X_AddOffset, X_RemoveOffset: integer; // Const = Hardcoded new coord; AddOffset = toprow + add offset;
    Y_Const, Y_AddOffset, Y_RemoveOffset: integer; // RemoveOffset = bottomrow + RemoveOffset
  End;

const WrapRules: array[0..13] of rWrapRule = (
// Block A
(x:50; y:0; CurrentFacing:Up; NewFacing:Right; X_Const:1; X_AddOffset:0; X_RemoveOffset:0; Y_Const:0; Y_AddOffset:151; Y_RemoveOffset:0),
(x:50; y:0; CurrentFacing:Left; NewFacing:Right; X_Const:1; X_AddOffset:0; X_RemoveOffset:0; Y_Const:0; Y_AddOffset:0; Y_RemoveOffset:150),
// Block B
(x:100; y:0; CurrentFacing:Up; NewFacing:Up; X_Const:0; X_AddOffset:1; X_RemoveOffset:0; Y_Const:200; Y_AddOffset:0; Y_RemoveOffset:0),
(x:100; y:0; CurrentFacing:Down; NewFacing:Left; X_Const:100; X_AddOffset:0; X_RemoveOffset:0; Y_Const:0; Y_AddOffset:51; Y_RemoveOffset:0),
(x:100; y:0; CurrentFacing:Right; NewFacing:Left; X_Const:100; X_AddOffset:0; X_RemoveOffset:0; Y_Const:0; Y_AddOffset:0; Y_RemoveOffset:150),
// Block C
(x:50; y:50; CurrentFacing:Left; NewFacing:Down; X_Const:0; X_AddOffset:1; X_RemoveOffset:0; Y_Const:101; Y_AddOffset:0; Y_RemoveOffset:0),
(x:50; y:50; CurrentFacing:Right; NewFacing:Up; X_Const:0; X_AddOffset:101; X_RemoveOffset:0; Y_Const:50; Y_AddOffset:0; Y_RemoveOffset:0),
// Block D
(x:0; y:100; CurrentFacing:Up; NewFacing:Right; X_Const:51; X_AddOffset:0; X_RemoveOffset:0; Y_Const:0; Y_AddOffset:51; Y_RemoveOffset:0),
(x:0; y:100; CurrentFacing:Left; NewFacing:Right; X_Const:51; X_AddOffset:0; X_RemoveOffset:0; Y_Const:0; Y_AddOffset:0; Y_RemoveOffset:50),
// Block E
(x:50; y:100; CurrentFacing:Right; NewFacing:Left; X_Const:150; X_AddOffset:0; X_RemoveOffset:0; Y_Const:0; Y_AddOffset:0; Y_RemoveOffset:50),
(x:50; y:100; CurrentFacing:Down; NewFacing:Left; X_Const:50; X_AddOffset:0; X_RemoveOffset:0; Y_Const:0; Y_AddOffset:151; Y_RemoveOffset:0),
// Block F
(x:0; y:150; CurrentFacing:Left; NewFacing:Down; X_Const:0; X_AddOffset:51; X_RemoveOffset:0; Y_Const:1; Y_AddOffset:0; Y_RemoveOffset:0),
(x:0; y:150; CurrentFacing:Down; NewFacing:Down; X_Const:0; X_AddOffset:101; X_RemoveOffset:0; Y_Const:1; Y_AddOffset:0; Y_RemoveOffset:0),
(x:0; y:150; CurrentFacing:Right; NewFacing:up; X_Const:0; X_AddOffset:51; X_RemoveOffset:0; Y_Const:150; Y_AddOffset:0; Y_RemoveOffset:0));

type
  TCubeCoordinate = (TL1, TR1, BL1, BR1, TL2, TR2, BL2, BR2);
  CubeCoordinates = set of TCubeCoordinate;
Const
  // First element is the edge of a face, the next 2 or paralel edge's of this line
  CubeFrame: array[0..11] of array[0..2] of CubeCoordinates = (
  ([TL1, TR1], [BL1, BR1], [TL2, TR2]),
  ([BL1, BR1], [TL1, TR1], [BL2, BR2]),
  ([BL2, BR2], [TL2, TR2], [BL1, BR1]),
  ([TL2, TR2], [TL1, TR1], [BL2, BR2]),

  ([BL1, TL1], [BR1, TR1], [BL2, TL2]),
  ([BR1, TR1], [BL1, TL1], [BR2, TR2]),
  ([BR2, TR2], [BR1, TR1], [BL2, TL2]),
  ([BL2, TL2], [BR2, TR2], [BL1, TL1]),

  ([TL1, TL2], [TR1, TR2], [BL1, BL2]),
  ([TR1, TR2], [TL1, TL2], [BR1, BR2]),
  ([BR1, BR2], [TR1, TR2], [BL1, BL2]),
  ([BL1, BL2], [BR1, BR2], [TL1, TL2]));

  type Face = Record
    x, y: integer;
    Coordinates: Array[uAOCUtils.TDirection] of TCubeCoordinate;
    function AllCoordinats: CubeCoordinates;
    function LineCoordinats(Direction: uAOCUtils.TDirection): CubeCoordinates;
   // TopLeft, TopRight, BottomLeft, BottemRight: TCubeCoordinate;
  end;


  function Face.AllCoordinats: CubeCoordinates;
  var
    CubeCoordinate: TCubeCoordinate;
  begin
    for CubeCoordinate in Coordinates do
      Include(Result, CubeCoordinate);
  end;

  function Face.LineCoordinats(Direction: uAOCUtils.TDirection): CubeCoordinates;
  var
    Next: uAOCUtils.TDirection;
  begin
    Next := uAOCUtils.TDirection((1 + Ord(Direction)) mod 4);
    Result := [Coordinates[Direction], Coordinates[Next]];
  end;

function TAdventOfCodeDay22.SolveB: Variant;

var
  Grid: TDictionary<TPosition, boolean>;
  PlayerPosition, NewPoint: TPosition;
  NewRules: TList<rWrapRule>;

  procedure BuildRules;
  var
    Faces: TList<Face>;
    CurrentFace, NewFace: Face;
    i: integer;

    function ShouldProcessFace(aCurrentFace: Face; OffsetX, OffsetY: integer): Boolean;
    var
      x,y: Integer;
      Position: TPosition;
      OtherFace: Face;
    begin
      x := aCurrentFace.X + OffsetX * 50 + 1;
      y := aCurrentFace.Y + OffsetY * 50 + 1;

      Position := Position.SetIt(x, y); // Point doesnt exist

      Result := Grid.ContainsKey(Position);
      if Result then
        for OtherFace in Faces do
          if InRange(x, OtherFace.X, OtherFace.X+50) and InRange(y, OtherFace.Y, OtherFace.Y+50) then
            Exit(False) // Already processed
    end;

    function PointsConnected(points: CubeCoordinates): Boolean;
    var
      i: integer;
    begin
      Result := False;
      for i := 0 to 11 do
        if CubeFrame[i][0] - points = [] then
          Exit(True)
    end;

    function FindOpposite(opposite: TCubeCoordinate; Line: CubeCoordinates): TCubeCoordinate;
    begin
      for result in Line do
        if PointsConnected([opposite, Result]) then
          Exit;
      Assert(False);


    end;

    function FindCubeCoordinate(opposite: TCubeCoordinate; Line, Cube: CubeCoordinates): TCubeCoordinate;
    var
      i: Integer;
    begin
      for i := 0 to 11 do
      begin
        if CubeFrame[i][0] = line then
        begin
          if CubeFrame[i][1] * Cube = [] then
            Result := FindOpposite(opposite, CubeFrame[i][1])
          else if CubeFrame[i][2] * Cube = [] then
            Result := FindOpposite(opposite, CubeFrame[i][2])
          else
            Assert(false);

          exit;
        end;
      end;

      Assert(False);

    end;

    function Fold(OffsetX, OffsetY: integer; aCurrentFace: Face; FoldFrom, FoldTo, CalcTo, CalcOp: Array of  uAOCUtils.TDirection; out aNewFace: Face): Boolean;
    var
      AllSourceCoordinates, MappedCoordinats: CubeCoordinates;
      CubeCoordinate: TCubeCoordinate;
      i: Integer;
    begin
      result := ShouldProcessFace(aCurrentFace, OffSetX, OffsetY);
      if not Result then
        Exit;

      aNewFace.x := aCurrentFace.X + OffsetX * 50;
      aNewFace.y := aCurrentFace.Y + OffsetY * 50;

      AllSourceCoordinates := [];
      MappedCoordinats := [];
      for CubeCoordinate in aCurrentFace.Coordinates do
        Include(AllSourceCoordinates, CubeCoordinate);

      for i := 0 to 1 do
      begin
        aNewFace.Coordinates[FoldTo[i]] := aCurrentFace.Coordinates[FoldFrom[i]];
        Include(MappedCoordinats, aNewFace.Coordinates[FoldTo[i]]);
      end;

      for i := 0 to 1 do
        aNewFace.Coordinates[CalcTo[i]] := FindCubeCoordinate(aNewFace.Coordinates[CalcOp[i]], MappedCoordinats, AllSourceCoordinates);
    end;

  var
    OffSetX, OffsetY: integer;
    Direction, NextDirection, OtherFaceDirection, OtherFaceDirection2 : uAOCUtils.TDirection;
    Rule: rWrapRule;
  begin
    Faces := TList<Face>.Create;

    CurrentFace.x := PlayerPosition.x-1;
    CurrentFace.y := PlayerPosition.y-1;
    CurrentFace.Coordinates[Up] := TL1;
    CurrentFace.Coordinates[Right] := TR1;
    CurrentFace.Coordinates[Down] := BR1;
    CurrentFace.Coordinates[Left] := BL1 ;

    Faces.Add(CurrentFace);

    for i := 0 to 5 do
    begin
      CurrentFace := Faces[i];

      // Look up
      if Fold(0, -1, CurrentFace, [up, right], [left, down], [up, right], [Left, Down], NewFace) then
        Faces.Add(NewFace);

      // Look down
      if Fold(0, 1, CurrentFace, [Left, Down], [Up, Right], [Left, Down], [Up, Right], NewFace) then
        Faces.Add(NewFace);

      // Look right
      if Fold(1, 0, CurrentFace, [Down, Right], [Left, Up], [Down, Right], [Left, Up], NewFace) then
        Faces.Add(NewFace);

      // Look Left
      if Fold(-1, 0, CurrentFace, [up, Left], [Right, down], [up, left], [Right, down], NewFace) then
        Faces.Add(NewFace);
    end;

    for CurrentFace in Faces do
    begin
      WriteLn(CurrentFace.X, ' ', CurrentFace.Y,
        ' TL: ',  TRttiEnumerationType.GetName(CurrentFace.Coordinates[Up]),
        ' TR: ',  TRttiEnumerationType.GetName(CurrentFace.Coordinates[Right]),
        ' BL: ',  TRttiEnumerationType.GetName(CurrentFace.Coordinates[Left]),
        ' BR: ',  TRttiEnumerationType.GetName(CurrentFace.Coordinates[Down]));
    end;

    for CurrentFace in Faces do
      for Direction := Low(uAOCUtils.TDirection) to High(uAOCUtils.TDirection) do
      begin
        NextDirection := uAOCUtils.TDirection((1 + Ord(Direction)) mod 4);
        for NewFace in Faces do
        begin
          if ((NewFace.x = CurrentFace.x) and (NewFace.y = CurrentFace.y)) or not ([CurrentFace.Coordinates[Direction], CurrentFace.Coordinates[NextDirection]] <= NewFace.AllCoordinats) then
            Continue;

          for OtherFaceDirection := Low(uAOCUtils.TDirection) to High(uAOCUtils.TDirection) do
            if CurrentFace.LineCoordinats(Direction) = NewFace.LineCoordinats(OtherFaceDirection) then
            begin
              OtherFaceDirection2 := uAOCUtils.TDirection((2 + Ord(OtherFaceDirection)) mod 4);

              Rule.X := CurrentFace.x;
              Rule.Y := CurrentFace.Y;
              Rule.CurrentFacing := Direction;
              Rule.NewFacing := OtherFaceDirection2;
              Rule.X_Const := 0;
              Rule.X_AddOffset := 0;
              Rule.X_RemoveOffset := 0;
              Rule.Y_Const := 0;
              Rule.Y_AddOffset := 0;
              Rule.Y_RemoveOffset := 0;

              case OtherFaceDirection of
                Right: Rule.X_Const := NewFace.X + 50;
                Down:  Rule.Y_Const := NewFace.Y + 50;
                Left:  Rule.X_Const := NewFace.X + 1;
                up:    Rule.Y_Const := NewFace.Y + 1;
              end;

              if OtherFaceDirection = Direction then
              begin
                if OtherFaceDirection in [Left, Right] then
                  Rule.Y_RemoveOffset := NewFace.y + 50
                else
                  Rule.X_RemoveOffset := NewFace.x + 50;
              end
              else
                if OtherFaceDirection in [Left, Right] then
                  Rule.Y_AddOffset := NewFace.y + 1
                else
                  Rule.X_AddOffset := NewFace.x + 1;

              NewRules.Add(Rule);
            end;
        end;
      end;
  end;

var
  OffSet, i, x,y: Integer;
  s: String;
  Split: TStringDynArray;
  Val: Boolean;
  Facing, OldFacing: uAOCUtils.TDirection;
  Rule, NewRule: rWrapRule;
begin
  PlayerPosition := PlayerPosition.SetIt(0,0);
  Grid := TDictionary<TPosition, boolean>.Create;
  NewRules := TList<rWrapRule>.Create;

  for y := 0 to FInput.Count -3 do
    for x := 1 to Length(FInput[y]) do
    begin
      if FInput[y][x] = ' ' then
        Continue;
      NewPoint := NewPoint.SetIt(x, y+1);
      Grid.Add(NewPoint, FInput[y][x] = '.');

      if PlayerPosition.x = 0 then
        PlayerPosition := NewPoint;
    end;

  BuildRules;

  for Rule in WrapRules do
  begin
    Val := False;
    for NewRule in NewRules do
    begin
      if (Rule.X = NewRule.X) and (Rule.Y = NewRule.Y) and (Rule.CurrentFacing =  NewRule.CurrentFacing) then
      begin
        Val := True;
        Assert(Rule.X_Const = NewRule.X_Const);
        Assert(Rule.X_AddOffset = NewRule.X_AddOffset);
        Assert(Rule.X_RemoveOffset = NewRule.X_RemoveOffset);
        Assert(Rule.Y_Const = NewRule.Y_Const, Rule.Y_Const.ToString + ' <> ' + NewRule.Y_Const.ToString);
        Assert(Rule.Y_AddOffset = NewRule.Y_AddOffset, Rule.Y_AddOffset.ToString + ' <> ' + NewRule.Y_AddOffset.ToString);
        Assert(Rule.Y_RemoveOffset = NewRule.Y_RemoveOffset);
      end;
    end;

    Assert(Val);
  end;

  s := FInput[FInput.Count-1];
  s := s.Replace('L', '|L|', [rfReplaceAll]).Replace('R', '|R|', [rfReplaceAll]);
  Split := SplitString(s, '|');

  Facing := Right;
  for s in Split do
  begin
    if s = 'R' then
    begin
      Facing := uAOCUtils.TDirection((Ord(Facing)+1) mod 4);
      Continue;
    end
    else if s = 'L' then
    begin
      Facing := uAOCUtils.TDirection((Ord(Facing)+3) mod 4);
      Continue;
    end;

    for i := 1 to StrToInt(s) do
    begin
      NewPoint := PlayerPosition.Clone.ApplyDirection(Facing);
      OldFacing := Facing;
      if not Grid.ContainsKey(NewPoint) then
      begin
        Val := False;
        for Rule in NewRules do
          if InRange(PlayerPosition.x, Rule.X+1, Rule.X+50) and InRange(PlayerPosition.y, Rule.y+1, Rule.y+50) and (Facing = Rule.CurrentFacing) then
          begin
            OffSet := PlayerPosition.x - Rule.X -1;
            if Facing in [Left, Right] then
              OffSet := PlayerPosition.y - Rule.Y -1;

            Facing := Rule.NewFacing;

            NewPoint.X := Rule.X_Const;
            if Rule.X_AddOffset > 0 then
              NewPoint.X := Rule.X_AddOffset + OffSet
            else if Rule.X_RemoveOffset > 0 then
              NewPoint.X := Rule.X_RemoveOffset - OffSet;

            NewPoint.Y := Rule.Y_Const;
            if Rule.Y_AddOffset > 0 then
              NewPoint.Y := Rule.Y_AddOffset + OffSet
            else if Rule.Y_RemoveOffset > 0 then
              NewPoint.Y := Rule.Y_RemoveOffset - OffSet;

            Val := True;
            Break;
          end;
        Assert(Val);
      end;

      if Grid.TryGetValue(NewPoint, Val) then
      begin
        if Val then
          PlayerPosition := NewPoint
        else
        begin
          Facing := OldFacing;
          break;
        end;
      end

    end;
  end;

  Result := 1000 * PlayerPosition.Y + 4 * PlayerPosition.X +  Ord(Facing);
  Grid.Free;
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay23'}
const
  Offsets: Array[0..7] of TPoint = (
    (X:-1; Y:-1), (X: 0; Y:-1), (X: 1; Y:-1),
    (X:-1; Y: 0),               (X: 1; Y: 0),
    (X:-1; Y: 1), (X: 0; Y: 1), (X: 1; Y: 1));
  RequierdOffsets: array[0..3] of array[0..2] of Integer = (
    (0,1,2), (5,6,7), (0,3,5), (2,4,7));

procedure TAdventOfCodeDay23.BeforeSolve;
var
  Grid, Blocked: TDictionary<TPoint,Boolean>;
  Changes: TDictionary<TPoint,TPoint>;

    function SpotIsFree2(CurrentPoint, Offset: TPoint): Boolean;
    var
      PointToCheck: Tpoint;
    begin
      PointToCheck := TPoint.Create(CurrentPoint);
      PointToCheck.Offset(Offset);
      Result := not Grid.ContainsKey(PointToCheck)
    end;

  function CreatePointWithOffset(aPoint: TPoint; Offset, OffsetIndex: integer): TPoint;
  begin
    Result := TPoint.Create(aPoint);
    Result.Offset(Offsets[RequierdOffsets[Offset][OffsetIndex]]);
  end;
    
  function GetNeighbors(aPoint: TPoint): integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to 7 do
      if not SpotIsFree2(aPoint, Offsets[i]) then
        Result := Result + 1 shl i;
  end;

  procedure Mark(aOld, aNew: TPoint);
  begin
    // Not moving or already blocked
    if (aNew = aOld) or Blocked.ContainsKey(aNew) then
      exit;

    // Found a change to the same spot, mark as blocked and revert other change
    if Changes.ContainsKey(aNew) then
    begin
      Blocked.Add(aNew, False);
      Changes.Remove(aNew);
      exit;
    end;

    // Mark change
    Changes.Add(aNew, aOld);
  end;

  function CalcPartA: integer; 
  var
    MinX, MaxX, MinY, MaxY: integer;
    Point: TPoint;
  begin
    MinX := MaxInt;
    MinY := MaxInt;
    MaxX := -MaxInt;
    Maxy := -MaxInt;

    for point in Grid.Keys do
    begin
      MaxX := Max(MaxX, point.x);
      MinX := Min(MinX, point.x);
      MaxY := Max(MaxY, point.y);
      MinY := Min(MinY, point.y);
    end;

    Result := (MaxX-MinX+1)*(MaxY-MinY+1) - Grid.Count;
  end;

var
  Round, OffsetIndex: integer;
  x, y, Mask, Neighbors: integer;
  Change: TPair<TPoint,TPoint>;
  point: TPoint;
  SpotFound: boolean;
begin
  inherited;
  
  Grid := TDictionary<TPoint,Boolean>.Create;
  Blocked := TDictionary<TPoint,Boolean>.Create;
  Changes := TDictionary<TPoint,TPoint>.Create;

  for y := 0 to FInput.Count-1 do
    for x := 1 to Length(FInput[0]) do
      if FInput[y][x] = '#' then
         Grid.Add(TPoint.Create(x, y), true);

  Round := 0;
  PartB := 0;
    
  while PartB = 0 do
  begin
    inc(Round);
    Changes.Clear;
    Blocked.Clear;
    
    for point in Grid.Keys do
    begin
      Neighbors := GetNeighbors(point);
      SpotFound := false;

      if Neighbors > 0 then
        for x := 0 to 3 do
        begin
          OffsetIndex := (Round+x-1) mod 4;
          Mask := (1 shl RequierdOffsets[OffsetIndex][0]) + (1 shl RequierdOffsets[OffsetIndex][1]) + (1 shl RequierdOffsets[OffsetIndex][2]);
          SpotFound := (Neighbors and Mask) = 0;

          if SpotFound then
          begin
            Mark(point, CreatePointWithOffset(Point, OffsetIndex, 1));
            break;
          end;
        end;

       if not SpotFound then
         Mark(point, point);
    end;

    if Changes.Count = 0 then
    begin
      PartB := Round;
      Break;
    end;
    
    for Change in Changes do
    begin
      Grid.Remove(Change.Value);
      Grid.Add(Change.Key, true);
    end;

    if Round = 10 then
      PartA := CalcPartA;
  end;

  Grid.Free;
  Blocked.Free; 
  Changes.Free;
end;

function TAdventOfCodeDay23.SolveA: Variant;
begin
  Result := PartA;
end;

function TAdventOfCodeDay23.SolveB: Variant;
begin
  Result := PartB; 
end;
{$ENDREGION}
{$REGION 'TAdventOfCodeDay24'}
procedure TAdventOfCodeDay24.BeforeSolve;
var
  x, y: Integer;
  s: string;
  Blizard: rBlizard;
begin
  inherited;

  Blizards := TDictionary<TPoint,rBlizard>.Create();
  maxX := Length(FInput[0])-2;
  MaxY := FInput.Count -2;

  for y := 0 to FInput.Count -1 do
    for x := 0 to Length(FInput[0])-1 do
    begin
      s := FInput[y][x+1];

      if s = '#' then
        Continue;
      if (y = 0) and (s = '.') then
        PlayerPosition := TPoint.Create(x-1,y-1);
      if (y = FInput.Count-1) and (s = '.') then
        ExitPosition := TPoint.Create(x-1,y-1);
      if s = '.' then
        Continue;

      Blizard.Position := TPoint.Create(x-1,y-1);
      Blizard.OffsetX := 0;
      Blizard.OffsetY := 0;
      case IndexStr(s, ['<', '>', '^', 'v']) of
        0: Blizard.OffsetX := -1;
        1: Blizard.OffsetX := 1;
        2: Blizard.OffsetY := -1;
        3: Blizard.OffsetY := 1;
      end;
      Blizards.Add(Blizard.Position, Blizard);
    end;
end;

procedure TAdventOfCodeDay24.AfterSolve;
begin
  inherited;
  Blizards.Free;
end;

function TAdventOfCodeDay24.FindPath(aFrom, aTo: TPoint; aTimePassed: integer): integer;
type
  VallyWork = record
    TimePassed: integer;
    Position: TPoint;
  end;
var
  i, j: Integer;
  s: String;
  Blizard: rBlizard;
  BlizardOrg: TPoint;
  Comparer : IComparer<VallyWork>;
  Queue: PriorityQueue<VallyWork>;
  Work, NewWork: VallyWork;
  CanMove: boolean;
  Seen: TDictionary<string, boolean>;
begin
  Result := 0;
  Seen := TDictionary<string, boolean>.Create;
  try
    Comparer := TComparer<VallyWork>.Construct(
    function(const Left, Right: VallyWork): integer
    begin
      Result := Sign(Left.TimePassed - Right.TimePassed);
    end);

    Queue := PriorityQueue<VallyWork>.Create(Comparer,Comparer);
    Work.Position := aFrom;
    Work.TimePassed := aTimePassed;
    Queue.Enqueue(Work);

    while Queue.Count > 0 do
    begin
      Work := Queue.Dequeue;

      s := Format('%d_%d_%d', [Work.Position.X, Work.Position.Y,  Work.TimePassed]);
      if Seen.ContainsKey(s) then
        Continue;
      Seen.Add(s, True);

      for i := 0 to 4 do
      begin
        NewWork.Position := TPoint.Create(Work.Position);
        NewWork.Position.Offset(DeltaX[i], DeltaY[i]);
        NewWork.TimePassed := Work.TimePassed + 1;

        if NewWork.Position = aTo then
          Exit(NewWork.TimePassed);

        if (NewWork.Position <> PlayerPosition) and (NewWork.Position <> ExitPosition) then
          if (NewWork.Position.X < 0) or (NewWork.Position.Y < 0) or (NewWork.Position.X > MaxX) or (NewWork.Position.Y > MaxY) then
            Continue;

        CanMove := True;
        for j := 0 to 3 do
        begin
          BlizardOrg := TPoint.Create(NewWork.Position);
          BlizardOrg.X := (BlizardOrg.X + maxX + DeltaX[j] * (NewWork.TimePassed mod maxX)) mod MaxX;
          BlizardOrg.Y := (BlizardOrg.Y + maxY + DeltaY[j] * (NewWork.TimePassed mod maxY)) mod MaxY;

          if Blizards.TryGetValue(BlizardOrg, Blizard) then
            if ((Blizard.OffsetX <> 0) and (Blizard.OffsetX + DeltaX[j] = 0)) or ((Blizard.OffsetY <> 0) and (Blizard.OffsetY + DeltaY[j] = 0)) then
            begin
              CanMove := False;
              break
            end;
        end;

        if CanMove then
          Queue.Enqueue(NewWork);
      end;
    end;
  finally
    Seen.Free;
  end;
end;


function TAdventOfCodeDay24.SolveA: Variant;
//const
//  DeltaX: Array[0..4] of integer = (1, -1, 0, 0, 0);
//  DeltaY: Array[0..4] of integer = (0, 0, -1, 1, 0);
//var
//  x,y, maxX, MaxY, i, j: Integer;
//  s: String;
//  Split: TStringDynArray;
//  Blizards: TDictionary<TPoint,rBlizard>;
//  Blizard: rBlizard;
//  PlayerPosition, ExitPosition, BlizardOrg: TPoint;
//  c: Char;
//  PartBComparer : IComparer<VallyWork>;
//  Queue: PriorityQueue<VallyWork>;
//  Work, NewWork: VallyWork;
//  CanMove: boolean;
//  Seen: TDictionary<string, boolean>;
begin
  PartA := FindPath(PlayerPosition, ExitPosition, 0);
  Result := PartA;


//  Blizards := TDictionary<TPoint,rBlizard>.Create();
//  Seen := TDictionary<string, boolean>.Create;
//  maxX := Length(FInput[0])-2;
//  MaxY := FInput.Count -2;
//
//  for y := 0 to FInput.Count -1 do
//    for x := 0 to Length(FInput[0])-1 do
//    begin
//      s := FInput[y][x+1];
//
//      if s = '#' then
//        Continue;
//      if (y = 0) and (s = '.') then
//        PlayerPosition := TPoint.Create(x-1,y-1);
//      if (y = FInput.Count-1) and (s = '.') then
//        ExitPosition := TPoint.Create(x-1,y-1);
//      if s = '.' then
//        Continue;
//
//      Blizard.Position := TPoint.Create(x-1,y-1);
//      Blizard.OffsetX := 0;
//      Blizard.OffsetY := 0;
//      case IndexStr(s, ['<', '>', '^', 'v']) of
//        0: Blizard.OffsetX := -1;
//        1: Blizard.OffsetX := 1;
//        2: Blizard.OffsetY := -1;
//        3: Blizard.OffsetY := 1;
//      end;
//      Blizards.Add(Blizard.Position, Blizard);
//    end;
//
//   PartBComparer := TComparer<VallyWork>.Construct(
//    function(const Left, Right: VallyWork): integer
//    begin
//      Result := Sign(Left.TimePassed - Right.TimePassed);
//    end);
//
//  Queue := PriorityQueue<VallyWork>.Create(PartBComparer,PartBComparer);
//  Work.Position := PlayerPosition;
//  Work.TimePassed := 0;
//  Queue.Enqueue(Work);
//
//  while Queue.Count > 0 do
//  begin
//    Work := Queue.Dequeue;
//
////    283 to low
////    284
//
//    s := Format('%d_%d_%d', [Work.Position.X, Work.Position.Y,  Work.TimePassed]);
//    if Seen.ContainsKey(s) then
//      Continue;
//    Seen.Add(s, True);
//
// //   Writeln(Work.Position.X, ' ',  Work.Position.Y, ' ',  Work.TimePassed);
//
//    for i := 0 to 4 do
//    begin
//      NewWork.Position := TPoint.Create(Work.Position);
//      NewWork.Position.Offset(DeltaX[i], DeltaY[i]);
//      NewWork.TimePassed := Work.TimePassed + 1;
//
//      if NewWork.Position = ExitPosition then
//        Exit(NewWork.TimePassed);
//
//      if (NewWork.Position <> PlayerPosition) and (NewWork.Position <> ExitPosition) then
//        if (NewWork.Position.X < 0) or (NewWork.Position.Y < 0) or (NewWork.Position.X > MaxX) or (NewWork.Position.Y > MaxY) then
//          Continue;
//
//      CanMove := True;
//      for j := 0 to 3 do
//      begin
//        BlizardOrg := TPoint.Create(NewWork.Position);
//          BlizardOrg.X := (BlizardOrg.X + (maxX) + DeltaX[j] * (NewWork.TimePassed mod (maxX))) mod(MaxX);
//
//          BlizardOrg.Y := (BlizardOrg.Y + (maxY) + DeltaY[j] * (NewWork.TimePassed mod (maxY))) mod(MaxY );
//
////
//        if (NewWork.Position <> PlayerPosition) and (NewWork.Position <> ExitPosition) then
//        begin
//
//        Assert(BlizardOrg.X >= 0);
//        Assert(BlizardOrg.X <= maxX);
//        Assert(BlizardOrg.Y >= 0);
//        Assert(BlizardOrg.Y <= maxY);
//
//        end;
//
//
//        if Blizards.TryGetValue(BlizardOrg, Blizard) then
//        begin
//          if (Blizard.OffsetX <> 0) and (Blizard.OffsetX + DeltaX[j] = 0) then
//          begin
//            CanMove := False;
//          end;
//          if (Blizard.OffsetY <> 0) and (Blizard.OffsetY + DeltaY[j] = 0) then
//          begin
//            CanMove := False;
//          end;
//        end;
//
//         if not CanMove then
//          Break;
//      end;
//
//      if CanMove then
//        Queue.Enqueue(NewWork);
//    end;
//
//
//
//
//
//  end;


end;

function TAdventOfCodeDay24.SolveB: Variant;
const
  DeltaX: Array[0..4] of integer = (1, -1, 0, 0, 0);
  DeltaY: Array[0..4] of integer = (0, 0, -1, 1, 0);
//var
//  maxX, MaxY: Integer;
//  Blizards: TDictionary<TPoint,rBlizard>;
//  PlayerPosition, ExitPosition, BlizardOrg: TPoint;





var
  TimePassed: integer;
//  Blizard: rBlizard;
//  TimePassed: integer;
//  c: Char;
//  PartBComparer : IComparer<VallyWork>;
//  Queue: PriorityQueue<VallyWork>;
//  Work, NewWork: VallyWork;
//  CanMove: boolean;
//  Seen: TDictionary<string, boolean>;
//
//  x,y, i, j: integer;
//  s: string;
begin
//  Blizards := TDictionary<TPoint,rBlizard>.Create();
//  maxX := Length(FInput[0])-2;
//  MaxY := FInput.Count -2;
//
//  for y := 0 to FInput.Count -1 do
//    for x := 0 to Length(FInput[0])-1 do
//    begin
//      s := FInput[y][x+1];
//
//      if s = '#' then
//        Continue;
//      if (y = 0) and (s = '.') then
//        PlayerPosition := TPoint.Create(x-1,y-1);
//      if (y = FInput.Count-1) and (s = '.') then
//        ExitPosition := TPoint.Create(x-1,y-1);
//      if s = '.' then
//        Continue;
//
//      Blizard.Position := TPoint.Create(x-1,y-1);
//      Blizard.OffsetX := 0;
//      Blizard.OffsetY := 0;
//      case IndexStr(s, ['<', '>', '^', 'v']) of
//        0: Blizard.OffsetX := -1;
//        1: Blizard.OffsetX := 1;
//        2: Blizard.OffsetY := -1;
//        3: Blizard.OffsetY := 1;
//      end;
//      Blizards.Add(Blizard.Position, Blizard);
//    end;

  TimePassed := PartA;
  TimePassed := FindPath(ExitPosition, PlayerPosition, TimePassed);
  TimePassed := FindPath(PlayerPosition, ExitPosition, TimePassed);
  Result := TimePassed
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
  TAdventOfCodeDay6, TAdventOfCodeDay7, TAdventOfCodeDay8, TAdventOfCodeDay9, TAdventOfCodeDay10,
  TAdventOfCodeDay11,TAdventOfCodeDay12,TAdventOfCodeDay13,TAdventOfCodeDay14,TAdventOfCodeDay15,
  TAdventOfCodeDay16,TAdventOfCodeDay17,TAdventOfCodeDay18,TAdventOfCodeDay19,TAdventOfCodeDay20,
  TAdventOfCodeDay21,TAdventOfCodeDay22,TAdventOfCodeDay23,TAdventOfCodeDay24]);

end.
