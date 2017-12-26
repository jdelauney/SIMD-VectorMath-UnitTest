{
 This file is used to report the configuration of the test run in the
 output, as there is no way to get compiler flags into a program.
}

{%region%====[ Native Configs ]================================================}

{ this is to test the copied file still reflects the native pascal inc}
{$ifdef NATIVE_CONFIG_1}
  const REP_FLAGS = '-O3, -dNATIVE_CONFIG_1';
  const REP_FILE_CSV = 'Native_Config_1.csv';
  const REP_FILE_MD = 'Native_Config_1.md';
  const REP_FILE_HTML = 'Native_Config_1.html';
{$endif}

{$ifdef NATIVE_CONFIG_2}
  const REP_FLAGS = '-O2, -dNATIVE_CONFIG_2';
  const REP_FILE_CSV = 'Native_Config_2.csv';
  const REP_FILE_MD = 'Native_Config_2.md';
  const REP_FILE_HTML = 'Native_Config_2.html';
{$endif}
{%endregion%}

{%region%====[ SSE Configs = ==================================================}

{$ifdef SSE_CONFIG_1}

  {$ifdef CPU64}
  const REP_FLAGS = '-CfSSE3, -Sv, -O3, -dUSE_ASM, -dSSE_CONFIG_1 (64bit)';
  const REP_FILE_CSV = 'SSE_Config_1_64bit.csv';
  const REP_FILE_MD = 'SSE_Config_1_64bit.md';
  const REP_FILE_HTML = 'SSE_Config_1_64bit.html';
  {$else}
  const REP_FLAGS = '-CfSSE3, -Sv, -O3, -dUSE_ASM, -dSSE_CONFIG_1 (32bit)';
  const REP_FILE_CSV = 'SSE_Config_1_32bit.csv';
  const REP_FILE_MD = 'SSE_Config_1_32bit.md';
  const REP_FILE_HTML = 'SSE_Config_1_32bit.html';
  {$endif}
{$endif}

{$ifdef SSE_CONFIG_1_TEST}
  {$ifdef CPU64}
  const REP_FLAGS = '-CfSSE3, -Sv, -dTEST -O3, -dUSE_ASM, -dSSE_CONFIG_1_TEST (64bit)';
  const REP_FILE_CSV = 'SSE_Config_1_Test_64bit.csv';
  const REP_FILE_MD = 'SSE_Config_1_Test_64bit.md';
  const REP_FILE_HTML = 'SSE_Config_1_Test_64bit.html';
  {$else}
  const REP_FLAGS = '-CfSSE3, -Sv, -dTEST -O3, -dUSE_ASM, -dSSE_CONFIG_1_TEST (32bit)';
  const REP_FILE_CSV = 'SSE_Config_1_Test_32bit.csv';
  const REP_FILE_MD = 'SSE_Config_1_Test_32bit.md';
  const REP_FILE_HTML = 'SSE_Config_1_Test_32bit.html';
  {$endif}
{$endif}

{%endregion%}

{%region%====[ SSE3 Configs ]==================================================}

{$ifdef SSE3_CONFIG_1}
  {$ifdef CPU64}
  const REP_FLAGS = '-CfSSE3, -Sv, -O3, -dUSE_ASM_SSE_3, -dSSE3_CONFIG_1 (64bit)';
  const REP_FILE_CSV = 'SSE3_Config_1_64bit.csv';
  const REP_FILE_MD = 'SSE3_Config_1_64bit.md';
  const REP_FILE_HTML = 'SSE3_Config_1_64bit.html';
  {$else}
  const REP_FLAGS = '-CfSSE3, -Sv, -O3, -dUSE_ASM_SSE_3, -dSSE3_CONFIG_1 (32bit)';
  const REP_FILE_CSV = 'SSE3_Config_1_32bit.csv';
  const REP_FILE_MD = 'SSE3_Config_1_32bit.md';
  const REP_FILE_HTML = 'SSE3_Config_1_32bit.html';
  {$endif}
{$endif}

{$ifdef SSE3_CONFIG_1_TEST}

  {$ifdef CPU64}
  const REP_FLAGS = '-CfSSE3, -Sv, -O3, -dTEST -dUSE_ASM_SSE_3, -dSSE3_CONFIG_1_TEST (64bit)';
  const REP_FILE_CSV = 'SSE3_Config_1_Test_64bit.csv';
  const REP_FILE_MD = 'SSE3_Config_1_Test_64bit.md';
  const REP_FILE_HTML = 'SSE3_Config_1_Test_64bit.html';
  {$else}
  const REP_FLAGS = '-CfSSE3, -Sv, -O3, -dTEST -dUSE_ASM_SSE_3, -dSSE3_CONFIG_1_TEST (32bit)';
  const REP_FILE_CSV = 'SSE3_Config_1_Test_32bit.csv';
  const REP_FILE_MD = 'SSE3_Config_1_Test_32bit.md';
  const REP_FILE_HTML = 'SSE3_Config_1_Test_32bit.html';
  {$endif}
{$endif}

{%endregion%}

{%region%====[ SSE4 Configs ]==================================================}

{$ifdef SSE4_CONFIG_1}
  {$ifdef CPU64}
  const REP_FLAGS = '-CfSSE42, -Sv, -O3, -dUSE_ASM_SSE_4, -dSSE4_CONFIG_1 (64bit)';
  const REP_FILE_CSV = 'SSE4_Config_1_64bit.csv';
  const REP_FILE_MD = 'SSE4_Config_1_64bit.md';
  const REP_FILE_HTML = 'SSE4_Config_1_64bit.html';
  {$else}
  const REP_FLAGS = '-CfSSE42, -Sv, -O3, -dUSE_ASM_SSE_4, -dSSE4_CONFIG_1 (32bit)';
  const REP_FILE_CSV = 'SSE4_Config_1_32bit.csv';
  const REP_FILE_MD = 'SSE4_Config_1_32bit.md';
  const REP_FILE_HTML = 'SSE4_Config_1_32bit.html';
  {$endif}
{$endif}

{$ifdef SSE4_CONFIG_1_TEST}
  {$ifdef CPU64}
  const REP_FLAGS = '-CfSSE42, -Sv, -O3, -dTEST, -dUSE_ASM_SSE_4, -dSSE4_CONFIG_1_TEST (64bit)';
  const REP_FILE_CSV = 'SSE4_Config_1_Test_64bit.csv';
  const REP_FILE_MD = 'SSE4_Config_1_Test_64bit.md';
  const REP_FILE_HTML = 'SSE4_Config_1_Test_64bit.html';
  {$else}
  const REP_FLAGS = '-CfSSE42, -Sv, -O3, -dTEST, -dUSE_ASM_SSE_4, -dSSE4_CONFIG_1_TEST (32bit)';
  const REP_FILE_CSV = 'SSE4_Config_1_Test_32bit.csv';
  const REP_FILE_MD = 'SSE4_Config_1_Test_32bit.md';
  const REP_FILE_HTML = 'SSE4_Config_1_Test_32bit.html';
  {$endif}
{$endif}

{%endregion%}

{%region%====[ AVX Configs ]= =================================================}

{$ifdef AVX_CONFIG_1}
  {$ifdef CPU64}
  const REP_FLAGS = '-CfAVX, -Sv, -O3 ,-dUSE_ASM_AVX, -dAVX_CONFIG_1 (64bit)';
  const REP_FILE_CSV = 'AVX_Config_1_64bit.csv';
  const REP_FILE_MD = 'AVX_Config_1_64bit.md';
  const REP_FILE_HTML = 'AVX_Config_1_64bit.html';
  {$else}
  const REP_FLAGS = '-CfAVX, -Sv, -O3 ,-dUSE_ASM_AVX, -dAVX_CONFIG_1 (32bit)';
  const REP_FILE_CSV = 'AVX_Config_1_32bit.csv';
  const REP_FILE_MD = 'AVX_Config_1_32bit.md';
  const REP_FILE_HTML = 'AVX_Config_1_32bit.html';
  {$endif}
{$endif}

{$ifdef AVX_CONFIG_1_TEST}
  {$ifdef CPU64}
  const REP_FLAGS = '-CfAVX, -Sv, -O3 , -dTEST, -dUSE_ASM_AVX, -dAVX_CONFIG_1_TEST (64bit)';
  const REP_FILE_CSV = 'AVX_Config_1_Test_64bit.csv';
  const REP_FILE_MD = 'AVX_Config_1_Test_64bit.md';
  const REP_FILE_HTML = 'AVX_Config_1_Test_64bit.html';
  {$else}
  const REP_FLAGS = '-CfAVX, -Sv, -O3 , -dTEST, -dUSE_ASM_AVX, -dAVX_CONFIG_1_TEST (32bit)';
  const REP_FILE_CSV = 'AVX_Config_1_Test_32bit.csv';
  const REP_FILE_MD = 'AVX_Config_1_Test_32bit.md';
  const REP_FILE_HTML = 'AVX_Config_1_Test_32bit.html';
  {$endif}
{$endif}

{%endregion%}

{%region%====[ AVX2 Configs ]==================================================}

{$ifdef AVX2_CONFIG_1}
  {$ifdef CPU64}
  const REP_FLAGS = '-CfAVX2, -Sv, -O3, -dUSE_ASM_AVX, -dAVX2_CONFIG_1 (64bit)';
  const REP_FILE_CSV = 'AVX2_Config_1_64bit.csv';
  const REP_FILE_MD = 'AVX2_Config_1_64bit.md';
  const REP_FILE_HTML = 'AVX2_Config_1_64bit.html';
  {$else}
  const REP_FLAGS = '-CfAVX2, -Sv, -O3, -dUSE_ASM_AVX, -dAVX2_CONFIG_1 (32bit)';
  const REP_FILE_CSV = 'AVX2_Config_1_32bit.csv';
  const REP_FILE_MD = 'AVX2_Config_1_32bit.md';
  const REP_FILE_HTML = 'AVX2_Config_1_32bit.html';
  {$endif}
{$endif}

{$ifdef AVX2_CONFIG_1_TEST}
  {$ifdef CPU64}
  const REP_FLAGS = '-CfAVX2, -Sv, -O3, -dTEST, -dUSE_ASM_AVX, -dAVX2_CONFIG_1_TEST (64bit)';
  const REP_FILE_CSV = 'AVX2_Config_1_Test_64bit.csv';
  const REP_FILE_MD = 'AVX2_Config_1_Test_64bit.md';
  const REP_FILE_HTML = 'AVX2_Config_1_Test_64bit.html';
  {$else}
  const REP_FLAGS = '-CfAVX2, -Sv, -O3, -dTEST, -dUSE_ASM_AVX, -dAVX2_CONFIG_1_TEST (32bit)';
  const REP_FILE_CSV = 'AVX2_Config_1_Test_32bit.csv';
  const REP_FILE_MD = 'AVX2_Config_1_Test_32bit.md';
  const REP_FILE_HTML = 'AVX2_Config_1_Test_32bit.html';
  {$endif}
{$endif}

{%endregion%}

