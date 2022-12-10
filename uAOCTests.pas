unit uAOCTests;

interface

uses
  System.SysUtils, Winapi.Windows,
  uAocUtils, AocSolutions, AOCBase, uAOCConfig;

type AOCTest = record
  AOCClass: TAdventOfCodeRef;
  ExpectedSolutionA, ExpectedSolutionB, OverRidenTestInput: String;
end;

type AOCTests = class
public
  Class procedure RunTests(aConfig: TAOCConfig);
end;

Const AOCTestData: array[0..9] of AOCTest =
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
 (AOCClass: TAdventOfCodeDay10;ExpectedSolutionA: '14860'; ExpectedSolutionB: 'RGZEHURK')
);

implementation

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

Var Test: AOCTest;
    AdventOfCode: TAdventOfCode;
    SolutionA, SolutionB: string;
    StartTickTest, StartTick: Int64;
begin
  Writeln('');
  StartTick := GetTickCount;
  for Test in AOCTestData do
  begin
    Writeln(Format('Running tests for %s', [Test.AOCClass.ClassName]));

    StartTickTest := GetTickCount;
    AdventOfCode := Test.AOCClass.Create(aConfig);
    AdventOfCode.Test(SolutionA, SolutionB, Test.OverRidenTestInput);
    AdventOfCode.Free;

    _Check('Part a', Test.ExpectedSolutionA, SolutionA);
    _Check('Part b', Test.ExpectedSolutionB, SolutionB);
    Writeln(FormAt('Total ticks %d', [GetTickCount - StartTickTest]));
    Writeln('');
  end;

  Writeln(Format('All tests done in %d ms', [GetTickCount - StartTick]));
end;

end.
