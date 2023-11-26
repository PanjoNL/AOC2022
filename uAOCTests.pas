unit uAOCTests;

interface

uses
  System.SysUtils, Winapi.Windows, system.Classes,
  uAocUtils, AocSolutions, AOCBase, uAOCConfig, uAocTimer;

type
  AOCTest = record
    AOCClass: TAdventOfCodeRef;
    ExpectedSolutionA, ExpectedSolutionB: String;
    LoadOverridenTestData: TLoadOverridenTestData
end;

type AOCTests = class
public
  Class procedure Day22Extra(aInput: TStrings);
  Class procedure RunTests(aConfig: TAOCConfig);
end;

Const AOCTestData: array[0..25] of AOCTest =
(
 (AOCClass: TAdventOfCodeDay1; ExpectedSolutionA: '69289'; ExpectedSolutionB: '205615'),
 (AOCClass: TAdventOfCodeDay2; ExpectedSolutionA: '17189'; ExpectedSolutionB: '13490'),
 (AOCClass: TAdventOfCodeDay3; ExpectedSolutionA: '7785'; ExpectedSolutionB: '2633'),
 (AOCClass: TAdventOfCodeDay4; ExpectedSolutionA: '534'; ExpectedSolutionB: '841'),
 (AOCClass: TAdventOfCodeDay5; ExpectedSolutionA: 'FRDSQRRCD'; ExpectedSolutionB: 'HRFTQVWNN'),
 (AOCClass: TAdventOfCodeDay6; ExpectedSolutionA: '1640'; ExpectedSolutionB: '3613'),
 (AOCClass: TAdventOfCodeDay7; ExpectedSolutionA: '1743217'; ExpectedSolutionB: '8319096'),
 (AOCClass: TAdventOfCodeDay8; ExpectedSolutionA: '1543'; ExpectedSolutionB: '595080'),
 (AOCClass: TAdventOfCodeDay9; ExpectedSolutionA: '6522'; ExpectedSolutionB: '2717'),
 (AOCClass: TAdventOfCodeDay10;ExpectedSolutionA: '14860'; ExpectedSolutionB: 'RGZEHURK'),
 (AOCClass: TAdventOfCodeDay11;ExpectedSolutionA: '108240'; ExpectedSolutionB: '25712998901'),
 (AOCClass: TAdventOfCodeDay12;ExpectedSolutionA: '408'; ExpectedSolutionB: '399'),
 (AOCClass: TAdventOfCodeDay13;ExpectedSolutionA: '5003'; ExpectedSolutionB: '20280'),
 (AOCClass: TAdventOfCodeDay14;ExpectedSolutionA: '665'; ExpectedSolutionB: '25434'),
 (AOCClass: TAdventOfCodeDay15;ExpectedSolutionA: '5688618'; ExpectedSolutionB: '12625383204261'),
 (AOCClass: TAdventOfCodeDay16;ExpectedSolutionA: '1647'; ExpectedSolutionB: '2169'),
 (AOCClass: TAdventOfCodeDay17;ExpectedSolutionA: '3133'; ExpectedSolutionB: '1547953216393'),
 (AOCClass: TAdventOfCodeDay18;ExpectedSolutionA: '3586'; ExpectedSolutionB: '2072'),
 (AOCClass: TAdventOfCodeDay19;ExpectedSolutionA: '1466'; ExpectedSolutionB: '8250'),
 (AOCClass: TAdventOfCodeDay20;ExpectedSolutionA: '8302'; ExpectedSolutionB: '656575624777'),
 (AOCClass: TAdventOfCodeDay21;ExpectedSolutionA: '168502451381566'; ExpectedSolutionB: '3343167719435'),
 (AOCClass: TAdventOfCodeDay22;ExpectedSolutionA: '133174'; ExpectedSolutionB: '15410'),
 (AOCClass: TAdventOfCodeDay22;ExpectedSolutionA: '6032'; ExpectedSolutionB: '5031'; LoadOverridenTestData: AOCTests.Day22Extra),
 (AOCClass: TAdventOfCodeDay23;ExpectedSolutionA: '3684'; ExpectedSolutionB: '862'),
 (AOCClass: TAdventOfCodeDay24;ExpectedSolutionA: '332'; ExpectedSolutionB: '942'),
 (AOCClass: TAdventOfCodeDay25;ExpectedSolutionA: '2-10==12-122-=1-1-22'; ExpectedSolutionB: '')
 );

implementation

class procedure AOCTests.Day22Extra(aInput: TStrings);
begin
  aInput.Clear;
  aInput.Add('        ...#    ');
  aInput.Add('        .#..    ');
  aInput.Add('        #...    ');
  aInput.Add('        ....    ');
  aInput.Add('...#.......#    ');
  aInput.Add('........#...    ');
  aInput.Add('..#....#....    ');
  aInput.Add('..........#.    ');
  aInput.Add('        ...#....');
  aInput.Add('        .....#..');
  aInput.Add('        .#......');
  aInput.Add('        ......#.');
  aInput.Add('                ');
  aInput.Add('10R5L5R10L4R5L5');
end;

class procedure AOCTests.RunTests(aConfig: TAOCConfig);

  procedure _Check(const DisplayName, Expected, Actual: String);
  begin
    if Expected <> '' then
      if Expected <> Actual then
      begin
        WriteLn(Format('FAIL, %s Expected: %s, Actual: %s', [DisplayName, Expected, Actual]));
        Assert(False);
      end
      else
        WriteLn(Format('PASS, %s', [DisplayName]))
  end;

Var
  Test: AOCTest;
  AdventOfCode: TAdventOfCode;
  TotalTime, TestTimer: AocTimer;
  SolutionA, SolutionB: string;
  Times: TStringList;
  ElapsedMicroSeconds: Integer;
  s: string;
begin
  Writeln('');

  Times := TStringList.Create;
  try
    TotalTime := AOCTimer.Start;
    for Test in AOCTestData do
    begin
      Writeln(Format('Running tests for %s', [Test.AOCClass.ClassName]));

      AdventOfCode := Test.AOCClass.Create(aConfig);

      TestTimer := AOCTimer.Start;
      AdventOfCode.Test(SolutionA, SolutionB, Test.LoadOverridenTestData);
      ElapsedMicroSeconds := TestTimer.ElapsedTime;
      Times.Add(Format('%s -> Time: %d %s', [Test.AOCClass.Classname, ElapsedMicroSeconds, TimeIndicator[MicroSeconds]]));
      AdventOfCode.Free;

      _Check('Part a', Test.ExpectedSolutionA, SolutionA);
      _Check('Part b', Test.ExpectedSolutionB, SolutionB);
      Writeln(FormAt('Total time %d %s', [ElapsedMicroSeconds, TimeIndicator[MicroSeconds]]));
      Writeln('');
    end;

    Writeln(Format('All tests done in %d %s', [TotalTime.ElapsedTime(MilliSeconds), TimeIndicator[MilliSeconds]]));
    for s in Times do
      WriteLn(s);
  finally
    Times.Free;
  end
end;

end.
