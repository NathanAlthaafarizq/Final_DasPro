------------ Nathan Althaafa Rizq - 261401103 ------------
Program SmartAudit;
uses crt;

type
  transaksi = record
  no, hari, kategori : longint;
  masuk, keinginan : boolean;
  nominal : longint;
  keterangan : string[30];
  kunci_lama, kunci_baru : longint;
end;

  data = record
  nama : string[30];
  tanggal, bulan, tahun : longint;
  anggaran : array[1..7] of longint;
  namaTarget : string[30];
  Target : longint;
  persen_butuh, persen_tabung, persen_darurat : longint;
end;

Procedure Garis;
var
  k : integer;

begin
  for k := 1 to 30 do 
  write('=');
  writeln;
end;

Function typeStr(n : longint): string;
var
  i : string;

begin
  str(n, i);
  typeStr := i;
end;

Function Persen(bagian, total : longint): longint;
begin
  if total <= 0 then Persen := 0
  else
    Persen := Round(bagian / total * 100);
end;

Function BacaBoolean(pesan : string) : boolean;
var
  i : string;
begin
  repeat
  write(pesan, '(y/t): ');
  readln(i);
  until (i = 'y') or (i = 'Y') or (i = 't') or (i = 'T');
  BacaBoolean := (i = 'y') or (i := 'Y');
end;

Function Kategori(i : longint): string;
begin
  case i of
    0 : Kategori := 'Pemasukan';
    1 : Kategori := 'Makanan';
    2 : Kategori := 'Transportasi';
    3 : Kategori := 'Pendidikan';
    4 : Kategori := 'Hiburan';
    5 : Kategori := 'Tagihan';
    6 : Kategori := 'Tabungan';
    7 : Kategori := 'Lainnya';
  end;
end;
----------------------------------------------------------
// Lanjut Disini.. kalau diatas kurang nanti buat aja, lalu di samping buat nama dan nim dengan format yang sama di awal dan batas akhir line

------------ Nathan Althaafa Rizq - 261401103 ------------
var 
  D : Data;
  T : array[1..100] of transaksi;
  jumlah_transaksi : longint;
  Pilih : longint;
----------------------------------------------------------

begin
clrscr;
// Penuhi yang kosong disini