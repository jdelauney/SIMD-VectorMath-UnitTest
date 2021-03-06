program VectorClassesTimingTest32;

{$mode objfpc}{$H+}

{$define NO_TIMING_TEST}

uses
  Interfaces, Forms, GuiTestRunner,
  // Vector2f Test Case
  Vector2fFunctionalTest,
  Vector2OperatorsTestCase,
  Vector2NumericsTestCase,
  // Vector3b Test Case
  Vector3bComparatorTest,
  // Vector4b Test Case
  Vector4bComparatorTest,
  Vector4iComparatorTest,
  // Vector4f Test Case
  VectorOperatorsTestCase,
  VectorNumericsTestCase,
  VectorOtherTestCase,
  VectorOnSelfTestCase,
  // HmgPlane Test Case
  HmgPlaneFunctionalTest,
  HmgPlaneComparatorTest,
  // Matrix Test Case
  MatrixFunctionalTest,  
  MatrixTestCase,
  // Quaternion Test Case
  QuaternionTestCase,
  // Vector4f and Plane Test Case
  VectorHelperTestCase,
  // bounding box et al
  BoundingBoxComparatorTest,  
  BSphereComparatorTest,
  AABBComparatorTest,  
{$ifndef NO_TIMING_TEST}
  // Vector2f Timing Test Case
  Vector2OperatorsTimingTest,
  // Vector3b Timing Test Case
  Vector3bTimingTest,
  // Vector4b Timing Test Case
  Vector4bTimingTest,
  Vector4iTimingTest,
  // Vector4f Timing Test Case
  VectorOperatorsTimingTest,
  VectorOperatorsOnSelfTimingTest,
  VectorNumericsTimingTest,
  VectorHelperTimingTest,
  // HmgPlane Timing Test
  HmgPlaneTimingTest,
  // Matrix Timing Test
  MatrixTimingTest,
  // Quaternion Timing Test
  QuaternionTimingTest,
  BoundingBoxTimingTest,
  BSphereTimingTest,  
  AABBTimingTest,
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

