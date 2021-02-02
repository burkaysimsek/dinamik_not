import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Ortalama Hesaplama', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dersAdi;
  int derspuan = 1;
  int dersHaftalikSaat = 1;
  List tumDersler;
  double ortalama = 0;
  static int sayac = 0;
  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Ortalama Hesaplama",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.black54),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate() &&
              formKey2.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: uygulamaGovdesi(),
    );
  }

  uygulamaGovdesi() {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(11),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: ("Ders Adını Giriniz"),
                      border: OutlineInputBorder(),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length <= 0) {
                        return ("Boş Bırakmayınız.");
                      }
                    },
                    onSaved: (kaydedilecekDeger) {
                      dersAdi = kaydedilecekDeger;
                      setState(() {
                        tumDersler.insert(
                            0, Ders(dersAdi, dersHaftalikSaat, derspuan));
                        ortalama = 0;
                        ortalamayiHesapla();
                      });
                    },
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 3),
                      child: Expanded(
                        child: Row(children: <Widget>[
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  items: derspuanItem(),
                                  value: dersHaftalikSaat,
                                  onChanged: (secilenpuan) {
                                    setState(() {
                                      dersHaftalikSaat = secilenpuan;
                                    });
                                  }),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black, width: 0.70),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Form(
                            key: formKey2,
                            child: Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: ("Puan"),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (girilenDeger) {
                                  if (girilenDeger.length <= 0) {
                                    return ("Boş Bırakmayınız.");
                                  } else {
                                    derspuan = int.parse(girilenDeger);
                                  }
                                },
                              ),
                            ),
                          ),
                        ]),
                      ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              height: 75,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: tumDersler.length == 0
                          ? " Lütfen ders ekleyin "
                          : "Ortalama : ",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.black54),
                    ),
                    TextSpan(
                      text: tumDersler.length == 0
                          ? ""
                          : "${ortalama.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                          color: Colors.black54),
                    )
                  ]),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Expanded(
                  child: ListView.builder(
                    itemBuilder: listeElemanlariniOlustur,
                    itemCount: tumDersler.length,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  derspuanItem() {
    List<DropdownMenuItem<int>> saatler = [];
    for (int i = 1; i < 30; i++) {
      saatler.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Saat",
        ),
      ));
    }

    return saatler;
  }

  Widget listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          leading: Icon(Icons.done_outline),
          title: Text(
            tumDersler[index].ad,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
          ),
          subtitle: Text(
            tumDersler[index].derspuan.toString() +
                " puan Ders Not Değer: " +
                tumDersler[index].haftalikSaat.toString(),
            style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  ortalamayiHesapla() {
    double toplamNot = 0;
    double haftaliksaat = 0;

    for (var oankiDers in tumDersler) {
      var puan = oankiDers.derspuan;
      var harfDegeri = oankiDers.haftalikSaat;
      haftaliksaat += harfDegeri;

      toplamNot += (harfDegeri * puan);
    }

    ortalama = toplamNot / haftaliksaat;
    print(tumDersler.length);
  }
}

class Ders {
  String ad;
  int haftalikSaat;
  int derspuan;

  Ders(this.ad, this.haftalikSaat, this.derspuan);
}
