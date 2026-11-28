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

transaksi = record                      // Nathan Althaafa Rizq - 261401103
    hari, kategori : longint;
    keinginan : boolean;
    nominal : longint;
    keterangan : string[30];
  end;

  daftar = array[1..100] of transaksi;

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

Function BacaBoolean(pesan : string) : boolean;   // Nathan Althaafa Rizq - 261401103
var
  i : string;
begin
  repeat
    write(pesan, ' (y/t): ');
    readln(i);
  until (i = 'y') or (i = 'Y') or (i = 't') or (i = 'T');
  BacaBoolean := (i = 'y') or (i = 'Y');
end;

Function NamaKategori(i : longint) : string;     
begin
  case i of
    1 : NamaKategori := 'Makan';
    2 : NamaKategori := 'Transportasi';
    3 : NamaKategori := 'Pendidikan';
    4 : NamaKategori := 'Lainnya';
  end;
end;

Procedure CatatTransaksi(var T : daftar; var n : longint);
var
  k : integer;
begin
  if n >= 100 then
  begin
    writeln('Data transaksi sudah penuh (maksimal 100).');
    exit;
  end;

  n := n + 1;
  Garis;
  writeln('Catat Transaksi ke-', n);
  Garis;

  with T[n] do
  begin
    hari := BacaAngka('Hari ke (1-30)    : ', 1, 30);

    writeln;
    for k := 1 to 4 do
      writeln(k, '. ', NamaKategori(k));
    kategori := BacaAngka('Pilih kategori    : ', 1, 4);

    nominal   := BacaAngka('Nominal (Rp)      : ', 1, 1000000000);
    keinginan := BacaBoolean('Termasuk keinginan? (t = kebutuhan)');
    write('Keterangan        : ');
    readln(keterangan);
  end;

  writeln;
  with T[n] do
  begin
    write('Tersimpan: hari ', hari, ', ', NamaKategori(kategori), ', Rp ', nominal, ', ');
    if keinginan then
      writeln('keinginan')
    else
      writeln('kebutuhan');
  end;
  writeln;
end;

// lanjutkan kodenya disini

var
  D : data;
  T : daftar;
  jumlah_transaksi : longint;
  i : longint;

begin
  jumlah_transaksi := 0;        // Nathan Althaafa Rizq - 261401103
  SetupAwal(D);                 // Nathan Althaafa Rizq - 261401103
  PemasukanDanRencana(D);       // Tessa Monica Tinambunan - 261401079 

  clrscr;                       // Nathan Althaafa Rizq - 261401103
  repeat
    CatatTransaksi(T, jumlah_transaksi);
  until (jumlah_transaksi >= 100) or not BacaBoolean('Catat transaksi lagi?');

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

  writeln('Daftar transaksi');
  Garis;
  for i := 1 to jumlah_transaksi do
    writeln(i, '. Hari ', T[i].hari, ' | ', NamaKategori(T[i].kategori), ' | Rp ', T[i].nominal);
  Garis;

  writeln('Tekan Enter untuk keluar...');
  readln;
end.

// Lanjutkan kode globalnya disini