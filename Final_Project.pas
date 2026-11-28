Program SmartAudit;                       // Nathan Althaafa Rizq - 261401103
uses crt;

type
    data = record
    nama : string[30];
    tanggal, bulan, tahun : longint;
    saldo_awal : longint;
    pemasukan : longint;                  // Tessa Monica Tinambunan - 261401079 
    target_tabungan : longint;
    anggaran : array[1..4] of longint;
  end;

Procedure Garis;                          // Nathan Althaafa Rizq - 261401103
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

Procedure PemasukanDanRencana(var P : data);    // Tessa Monica Tinambunan - 261401079 
    target_tabungan : longint;
var
  i : integer;
  totalAnggaran : longint;
begin
  clrscr;
  Garis;
  writeln('Pemasukan dan Rencana');
  Garis;

  with P do
  begin
    pemasukan := BacaAngka('Total pemasukan (Rp) : ', 0, 1000000000);

    writeln;
    writeln('--- Anggaran Per Kategori ---');

    repeat
      totalAnggaran := 0;

      anggaran[1] := BacaAngka('Anggaran makan        : ', 0, pemasukan);
      anggaran[2] := BacaAngka('Anggaran transportasi : ', 0, pemasukan);
      anggaran[3] := BacaAngka('Anggaran pendidikan   : ', 0, pemasukan);
      anggaran[4] := BacaAngka('Anggaran lainnya      : ', 0, pemasukan);

      for i := 1 to 4 do
        totalAnggaran := totalAnggaran + anggaran[i];

      if totalAnggaran > pemasukan then
        writeln('Total anggaran melebihi pemasukan. Input ulang.');

    until totalAnggaran <= pemasukan;

    writeln;
    target_tabungan := BacaAngka('Target tabungan (Rp) : ', 0, 1000000000);
  end;

  writeln;
  Garis;
  writeln('Pemasukan dan rencana berhasil disimpan.');
  Garis;
end;

// Lanjutkan kode globalnya disini

var
  D : data;

begin
  SetupAwal(D);                 // Nathan Althaafa Rizq - 261401103
  PemasukanDanRencana(D);       // Tessa Monica Tinambunan - 261401079 

  writeln;                      // Nathan Althaafa Rizq - 261401103
  Garis;
  writeln('Setup awal dan rencana selesai');
  Garis;
  with D do
  begin
    writeln('Nama       : ', nama);
    writeln('Mulai      : ', tanggal, '/', bulan, '/', tahun);
    writeln('Saldo awal : Rp ', saldo_awal);
    writeln('Pemasukan  : Rp ', pemasukan);
    writeln('Target     : Rp ', target_tabungan);
    Garis;
  end;
  writeln('Tekan Enter untuk keluar...');
  readln;
end.

// Lanjutkan kode globalnya disini