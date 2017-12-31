program VectorClassesTimingTest32;

{$mode objfpc}{$H+}

{$define NO_TIMING_TEST}

uses
  Interfaces, Forms, GuiTestRunner,
  // Vector2f Test Case
  Vector2OperatorsTestCase,
  Vector2NumericsTestCase,
  // Vector4f Test Case
  VectorOperatorsTestCase,
  VectorNumericsTestCase,
  VectorOtherTestCase,
  VectorOnSelfTestCase,
  // Matrix Test Case
  MatrixTestCase,
  // Quaternion Test Case
  QuaternionTestCase,
  // Vector4f and Plane Test Case
  VectorAndHmgPlaneHelperTestCase,
{$ifndef NO_TIMING_TEST}
  // Vector2f Timing Test Case
  Vector2OperatorsTimingTest,
//  glz_2DHelper_test_cases,
  // Vector4f Timing Test Case
  VectorOperatorsTimingTest,
  VectorOperatorsOnSelfTimingTest,
  VectorNumericsTimingTest,
  // Matrix Timing Test
  MatrixTimingTest,
  // Quaternion Timing Test
  QuaternionTimingTest,
  { ensure your code is included before this line}
  ReportTest,
{$endif}
  GLZVectorMath;

begin
  Application.Title:='VectorClassesUnitTest';
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

