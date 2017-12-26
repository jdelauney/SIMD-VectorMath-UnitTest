unit ReportTest;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest;

{$I config.inc}

Type
  { TFileWriteTest }
  TFileWriteTest = class (TTestCase)
  published
    procedure WriteFile;
    procedure WriteMarkDown;
    procedure WriteHTML;
    procedure WriteForumBBCode;
    procedure ClearLog;

  end;

implementation

{ TFileWriteTest }

procedure TFileWriteTest.WriteFile;
begin
  sl.SaveToFile('Results' + DirectorySeparator + REP_FILE_CSV);
end;

procedure TFileWriteTest.WriteMarkDown;
begin
  ml.SaveToFile('Results' + DirectorySeparator + REP_FILE_MD);
end;

procedure TFileWriteTest.WriteHTML;
begin
  hl.Add('</tbody>');
  hl.Add('</table>');
  hl.Add('</body>');
  hl.Add('</html>');
  hl.SaveToFile('Results' + DirectorySeparator + REP_FILE_HTML);
end;

procedure TFileWriteTest.WriteForumBBCode;
begin
  fhl.Add('[/table]');
  fhl.SaveToFile('Results' + DirectorySeparator + 'BBCODE_'+REP_FILE_HTML);
end;

procedure TFileWriteTest.ClearLog;
begin
  sl.Free;
  ml.free;
  hl.free;
  fhl.free;
  DoInitLists;
end;

initialization
  RegisterTest(TFileWriteTest ); // must always be last in list!!!

end.

