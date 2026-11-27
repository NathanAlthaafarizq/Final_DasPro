// ------------ Nathan Althaafa Rizq - 261401103 ------------
Program SmartAudit;
uses crt;

type
    data = record
    nama : string[30];
    tanggal, bulan, tahun : longint;
    saldo_awal : longint;
  end;

Procedure Garis;
var
  k : integer;
begin
  for k := 1 to 30 do
    write('=');
  writeln;
end;

Function BacaAngka(pesan : string; minimal, maksimal : longint) : longint;
var
  teks : string;
  angka : longint;
  kode : integer;
  valid : boolean;
begin
  repeat
    write(pesan);
    readln(teks);
    val(teks, angka, kode);
    valid := (kode = 0) and (angka >= minimal) and (angka <= maksimal);
    if not valid then
      writeln('Input tidak valid. Isi angka ', minimal, ' sampai ', maksimal, '.');
  until valid;
  BacaAngka := angka;
end;
// Lanjutkan Kodenya Disini

// ------------ Nathan Althaafa Rizq - 261401103 ------------
Procedure SetupAwal(var P : data);
begin
  clrscr;
  Garis;
  writeln('Setup Awal SmartAudit');
  Garis;
  with P do
  begin
  repeat
    write('Nama            : ');
    readln(P.nama);
  until length(P.nama) > 0;
  tanggal    := BacaAngka('Tanggal mulai   : ', 1, 31);
  bulan      := BacaAngka('Bulan mulai     : ', 1, 12);
  tahun      := BacaAngka('Tahun mulai     : ', 2000, 2100);
  saldo_awal := BacaAngka('Saldo awal (Rp) : ', 0, 1000000000);
  end;
end;

var
  D : data;

begin
  SetupAwal(D);
  writeln;
  Garis;
  writeln('Setup awal selesai');
  Garis;
  with D do
  begin
    writeln('Nama       : ', nama);
    writeln('Mulai      : ', tanggal, '/', bulan, '/', tahun);
    writeln('Saldo awal : Rp ', saldo_awal);
    Garis;
  end;
  writeln('Tekan Enter untuk keluar...');
  readln;
end.
// Lanjutkan kode globalnya disini
