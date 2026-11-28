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
  arrayKunci = array[1..100] of longint;  // Maria Cinta Murni Zai - 261401090

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

Function BuatKunci(idx : longint; tr : transaksi; kunciPrev : longint) : longint;   // Maria Cinta Murni Zai - 261401090
var i, sumKet : longint;
begin
  sumKet := 0;
  for i := 1 to length(tr.keterangan) do
    sumKet := sumKet + (ord(tr.keterangan[i]) * i);
  BuatKunci := abs((idx * 37) + (tr.hari * 19) + (tr.kategori * 13) +
                   tr.nominal + sumKet + (kunciPrev * 7)) mod 1000000;
end;

Procedure KunciDanPeringatan(var P : data; var T : daftar; n : longint; var kunciTrx : arrayKunci);
var i, totalKeluar, kunciPrev : longint;
begin
  if n <= 0 then exit;
  if n = 1 then kunciPrev := 0 else kunciPrev := kunciTrx[n - 1];
  kunciTrx[n] := BuatKunci(n, T[n], kunciPrev);
  writeln('>> Kunci transaksi ke-', n, ' : ', kunciTrx[n]);

  totalKeluar := 0;
  for i := 1 to n do totalKeluar := totalKeluar + T[i].nominal;

  if (P.anggaran[T[n].kategori] > 0) and (T[n].nominal > P.anggaran[T[n].kategori]) then
    writeln('>> PERINGATAN: Pengeluaran melebihi anggaran ', NamaKategori(T[n].kategori), '!');
  if totalKeluar > (P.saldo_awal + P.pemasukan) then
    writeln('>> PERINGATAN: Total pengeluaran melebihi saldo awal + pemasukan!');
end;

Function Cek30HariSelesai(var T : daftar; n : longint) : boolean;
var i : longint; adaHari30 : boolean;
begin
  adaHari30 := false;
  for i := 1 to n do
    if T[i].hari = 30 then adaHari30 := true;
  Cek30HariSelesai := adaHari30 or (n >= 30);
end;

Procedure AuditDanRekonsiliasi(var P : data; var T : daftar; n : longint; var kunciTrx : arrayKunci);
var
  i, totalKeluar, saldoAkhir, kunciPrev : longint;
  katAman : array[1..4] of longint;
  syarat1, syarat2, syarat3 : boolean;
begin
  totalKeluar := 0;
  for i := 1 to 4 do katAman[i] := 0;
  syarat1 := true;
  syarat2 := true;

  for i := 1 to n do
  begin
    totalKeluar := totalKeluar + T[i].nominal;
    katAman[T[i].kategori] := katAman[T[i].kategori] + T[i].nominal;
    if i = 1 then kunciPrev := 0 else kunciPrev := kunciTrx[i - 1];
    if kunciTrx[i] <> BuatKunci(i, T[i], kunciPrev) then syarat1 := false;
  end;

  for i := 1 to 4 do
    if (P.anggaran[i] > 0) and (katAman[i] > P.anggaran[i]) then syarat2 := false;
  if totalKeluar > (P.saldo_awal + P.pemasukan) then syarat2 := false;

  saldoAkhir := (P.saldo_awal + P.pemasukan) - totalKeluar;
  syarat3 := saldoAkhir >= 0;

  Garis;
  writeln('Audit dan Rekonsiliasi (3 Syarat)');
  Garis;
  writeln('Syarat 1 (Rantai kunci valid) : ', syarat1);
  writeln('Syarat 2 (Anggaran & dana aman): ', syarat2);
  writeln('Syarat 3 (Saldo akhir >= 0)  : ', syarat3, ' (Saldo: Rp ', saldoAkhir, ')');
  if syarat1 and syarat2 and syarat3 then
    writeln('Hasil Audit: SEMUA 3 SYARAT TERPENUHI.')
  else
    writeln('Hasil Audit: BELUM SEMUA SYARAT TERPENUHI.');
  Garis;
end;

var
  D : data;
  T : daftar;
  jumlah_transaksi : longint;
  i : longint;
  kunciRantai : arrayKunci;     // Maria Cinta Murni Zai - 261401090

begin
  jumlah_transaksi := 0;        // Nathan Althaafa Rizq - 261401103
  SetupAwal(D);                 // Nathan Althaafa Rizq - 261401103
  PemasukanDanRencana(D);       // Tessa Monica Tinambunan - 261401079 

  clrscr;                       // Nathan Althaafa Rizq - 261401103
  repeat
    CatatTransaksi(T, jumlah_transaksi);
    KunciDanPeringatan(D, T, jumlah_transaksi, kunciRantai);  // Maria Cinta Murni Zai - 261401090
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

  if Cek30HariSelesai(T, jumlah_transaksi) then   // Maria Cinta Murni Zai - 261401090
    writeln('Cek 30 hari: SUDAH SELESAI / MENCAPAI HARI KE-30.')
  else
    writeln('Cek 30 hari: BELUM SELESAI.');

  AuditDanRekonsiliasi(D, T, jumlah_transaksi, kunciRantai);

  writeln('Tekan Enter untuk keluar...');
  readln;
end.

// Lanjutkan kode globalnya disini