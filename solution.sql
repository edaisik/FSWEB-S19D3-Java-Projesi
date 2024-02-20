1) ÖRNEK SORU: Yazar tablosunu KEMAL UYUMAZ isimli yazarı ekleyin.

INSERT INTO yazar (yazarad,yazarsoyad)
VALUES("KEMAL","UYUMAZ");

2) Biyografi türünü tür tablosuna ekleyiniz.

INSERT INTO  tur (turadi)
VALUES("Biyografi");

3) 10A sınıfı olan ÇAĞLAR ÜZÜMCÜ isimli erkek, sınıfı 9B olan LEYLA ALAGÖZ isimli kız ve sınıfı 11C olan Ayşe Bektaş isimli kız öğrencileri tek sorguda ekleyin.

 INSERT INTO  ogrenci (ograd,ogrsoyad,sinif,cinsiyet)
 VALUES("Çağlar","Üzümcü","10A","E")
 ("Leyla","Alagöz","9B","K")
("Ayşe","Bektaş","11C","K")

4) Öğrenci tablosundaki rastgele bir öğrenciyi yazarlar tablosuna yazar olarak ekleyiniz.

INSERT INTO  yazar (yazarad,yazarsoyad)
 SELECT ograd,ogrsoyad FROM ogrenci
 ORDER BY RANDOM()
 LIMIT 1;

5) Öğrenci numarası 10 ile 30 arasındaki öğrencileri yazar olarak ekleyiniz.

INSERT INTO  yazar (yazarad,yazarsoyad)
 SELECT ograd,ogrsoyad FROM ogrenci
WHERE ogrno between 10 and 30;

6) Nurettin Belek isimli yazarı ekleyip yazar numarasını yazdırınız.
(Not: Otomatik arttırmada son arttırılan değer @@IDENTITY değişkeni içinde tutulur.)

INSERT INTO  yazar (yazarad,yazarsoyad)
VALUES ("Nurettin","Belek")
SELECT @IDENTITY as yazarno;

7) 10B sınıfındaki öğrenci numarası 3 olan öğrenciyi 10C sınıfına geçirin.

UPDATE ogrenci
SET sinif = "10C"
WHERE ogrno = 3;

8) 9A sınıfındaki tüm öğrencileri 10A sınıfına aktarın

UPDATE ogrenci
SET sinif = "10A"
WHERE sinif = "9A";

9) Tüm öğrencilerin puanını 5 puan arttırın.

UPDATE ogrenci
SET puan = (puan+5);

10) 25 numaralı yazarı silin.

DELETE FROM yazar
WHERE  yazarno = 25;

11) Doğum tarihi null olan öğrencileri listeleyin. (insert sorgusu ile girilen 3 öğrenci listelenecektir)

select * from ogrenci
where dtarih is null;

12) Doğum tarihi null olan öğrencileri silin.

delete from ogrenci
where dtarih is null;

13) Kitap tablosunda adı a ile başlayan kitapların puanlarını 2 artırın.

UPDATE kitap
SET puan = puan+2
where kitapadi alike "a%";

14) Kişisel Gelişim isimli bir tür oluşturun.

INSERT INTO tur (turadi)
values ("kişisel gelişim");

15) Kitap tablosundaki Başarı Rehberi kitabının türünü bu tür ile değiştirin.

UPDATE kitap
SET turno = (select turno from tur  where turadi = "kişisel gelişim")
where kitapadi = "Başarı Rehberi";

16) Öğrenci tablosunu kontrol etmek amaçlı tüm öğrencileri görüntüleyen "ogrencilistesi" adında bir prosedür oluşturun.

CREATE FUNCTION getOgrenciListesi()
LANGUAGE "sql"
as $BODY$
select * from ogrenci
$BODY$;

17) Öğrenci tablosuna yeni öğrenci eklemek için "ekle" adında bir prosedür oluşturun.

CREATE FUNCTION ekle(name character varying,surname character varying, gender character varying,birthday character varying, class character varying, point character varying)
LANGUAGE "sql"
as $BODY$
INSERT INTO ogrenci(ogr,ogrsoyad,dtarih,cinsiyet,sinif,puan)
VALUES(name, surname,birthday,gender,class,point)
$BODY$;

18) Öğrenci noya göre öğrenci silebilmeyi sağlayan "sil" adında bir prosedür oluşturun.
CREATE FUNCTION sil(student_no integer)
LANGUAGE "sql"
as $BODY$
delete * from ogrenci where ogrenci no = student_no
$BODY$;

19) Öğrenci numarasını kullanarak kolay bir biçimde öğrencinin sınıfını değiştirebileceğimiz bir prosedür oluşturun.

CREATE FUNCTION updateSinif(student_no integer,new_class character varying)
LANGUAGE "sql"
as $BODY$
update ogrenci
set sinif = new_class
where ogrno = student_no
$BODY$;

20) Öğrenci adı ve soyadını "Ad Soyad" olarak birleştirip, ad soyada göre kolayca arama yapmayı sağlayan bir prosedür yazın.

CREATE FUNCTION search(full_name character varying)
LANGUAGE "sql"
as $BODY$
select * from ogrenci
where CONCAT(ograd,ogrsoyad) LIKE CONCAT("%",full_name,"%")

$BODY$;

21) Daha önceden oluşturduğunu tüm prosedürleri silin.

DROP FUNCTION IF EXISTS getOgrenciListesi();
DROP FUNCTION IF EXISTS ekle(character varying, character varying, character varying, character varying, character varying, character varying);
DROP FUNCTION IF EXISTS sil(integer);
DROP FUNCTION IF EXISTS updateSinif(integer, character varying);
DROP FUNCTION IF EXISTS search(character varying);


#Esnek görevler (Esnek görevlerin hepsini Select in Select ile gerçekleştirmeniz beklenmektedir.)
22) Select in select yöntemiyle dram türündeki kitapları listeleyiniz.

SELECT * FROM kitap
where turno (select turno from tur where turadi = "DRAM")

23) Adı e harfi ile başlayan yazarların kitaplarını listeleyin.
SELECT * FROM kitap
where  yazarno (select yazarno from yazar  where yazarad like "E%");

24) Kitap okumayan öğrencileri listeleyiniz.

select * from ogrenci where  ogrno not in  (select ogrno from islem);

25) Okunmayan kitapları listeleyiniz
select * from kitap where kitapno not in (select kitapno from islem);

26) Mayıs ayında okunmayan kitapları listeleyiniz.
SELECT * FROM kitap WHERE kitapno NOT IN (SELECT kitapno FROM islem WHERE EXTRACT(MONTH FROM atarih) = 5);
