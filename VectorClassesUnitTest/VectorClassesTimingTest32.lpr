program VectorClassesTimingTest32;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner,
  // Test Case
  VectorOperatorsTestCase,
  VectorNumericsTestCase,
  VectorOtherTestCase,
  VectorOnSelfTestCase,
  // Timing Test Case
  VectorOperatorsTimingTest,
  VectorNumericsTimingTest,
  VectorOnSelfTimingTest,

  { ensure your code is included before this line}
  ReportTest ;

begin
  Application.Title:='VectorClassesUnitTest32';
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

