unit ReportTest;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, fpcunit, testregistry, BaseTimingTest;

{$I config.inc}

Type
  { TFileWriteTest }
  TFileWriteTest = class (TGroupTimingTest)
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
  sl.SaveToFile('Results' + DirectorySeparator + self.RGString + DirectorySeparator + REP_FILE_CSV);
end;

procedure TFileWriteTest.WriteMarkDown;
begin
  ml.SaveToFile('Results' + DirectorySeparator + self.RGString + DirectorySeparator +REP_FILE_MD);
end;

procedure TFileWriteTest.WriteHTML;
begin
  hl.Strings[HeaderPos] := '<h1>FPC SSE/AVX '+ RGString +' test cases.</h1>';
  hl.Add('</tbody>');
  hl.Add('</table>');
  hl.Add('</div>');
  hl.Add('</body>');
  hl.Add('</html>');
  hl.SaveToFile('Results' + DirectorySeparator +  self.RGString  + DirectorySeparator + REP_FILE_HTML);
end;

procedure TFileWriteTest.WriteForumBBCode;
begin
  fhl.Add('[/table]');
  fhl.SaveToFile('Results' + DirectorySeparator + self.RGString  + DirectorySeparator + 'BBCODE_'+REP_FILE_HTML);
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
RegisterTest('Vector2f',TFileWriteTest );
RegisterTest('Vector4f',TFileWriteTest );
RegisterTest('Matrix4f',TFileWriteTest );
RegisterTest('Quaternion',TFileWriteTest ); // must always be last in list!!!

end.

