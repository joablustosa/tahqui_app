import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';
import '../../Models/ItemPesquisa.dart';
import '../../Models/UsuarioRetorno.dart';
import '../../Services/syncronize.dart';
import '../Usuario/Configuracao.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _itemSelecionado = 0;

  final List<Widget> _listaDePaginas = <Widget>[
    const Home(),
    const Configuracao(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _itemSelecionado = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _itemSelecionado,
      //   selectedItemColor: Colors.purpleAccent,
      //   unselectedItemColor: Colors.grey,
      //   onTap: _onItemTapped,
      //   items: const [
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.home,
      //         ),
      //         label: "Início"
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.settings,
      //         ),
      //         label: "Configuração"
      //     ),
      //   ],
      // ),
      body: _listaDePaginas.elementAt(_itemSelecionado),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _tCodigo = TextEditingController();
  final _controllerPesquisa = TextEditingController();
  FocusNode myFocusNode = new FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final qrKey = GlobalKey(debugLabel: 'QR');
  String ticket = '';
  List<ItemPesquisa> listaPesquisa = [];
  final _advancedDrawerController = AdvancedDrawerController();
  final LocalStorage storage = new LocalStorage('local');
  String nickname = "";
  String orderBy = "0";
  UsuarioRetorno? usuarioRetorno;

  _formataDataHora(data) {
    var t = DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(data));
    return t.toString();
  }

  // _buscaDados() {
  //   nickname = storage.getItem('nickname');
  // }

  Future enviaPesquisa(String pesquisa, String order) async {
    final String _baseUrl =
        'tahqui.herokuapp.com';
    final String _charactersPath = '/api/Item';
    var url = Uri.http(
        _baseUrl, _charactersPath, {'OrderBy': order, 'Description': pesquisa});
    List<ItemPesquisa> itens;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List listaResponse = jsonDecode(response.body);
      itens = <ItemPesquisa>[];
      for (Map map in listaResponse) {
        ItemPesquisa m = new ItemPesquisa.fromJson(map as Map<String, dynamic>);
        itens.add(m);
      }
    } else {
      throw Exception();
    }
    return itens;
  }

  Future isInternet() async {
    await SyncronizationData.isInternet().then((connection) => {
          if (connection) {salvarnaApi()}
        });
  }

  Future salvarnaApi() async {
    await SyncronizationData()
        .recuperaListaCodigosAlterados()
        .then((codigoList) async {
      await SyncronizationData().salvarnaApi(codigoList);
    });
  }

  logoutApp() {
    final LocalStorage usuarioStorage = new LocalStorage('local');
    usuarioStorage.clear();
    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  buscaUsuario() {
    final LocalStorage usuarioStorage = new LocalStorage('local');
    setState(() {
      usuarioRetorno = usuarioStorage.getItem('usuario');
    });
  }

  @override
  void initState() {
    super.initState();
    isInternet();
    buscaUsuario();
    //_buscaDados();
  }

  Widget cards(image, title, price) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6.0,
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              image,
              height: 80,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 6.0,
                      ),
                    ],
                    color: Colors.teal),
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.only(top: 4),
                child: Text(price,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdropColor: Colors.white,
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),
            bottom: PreferredSize(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  child: Container(
                    child: TextField(
                      autofocus: false,
                      onSubmitted: (val) {
                        setState(() {
                          enviaPesquisa(_controllerPesquisa.text, orderBy);
                        });
                      },
                      controller: _controllerPesquisa,
                      cursorColor: Theme.of(context).primaryColor,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 16, top: 12),
                          border: InputBorder.none,
                          //icon: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  enviaPesquisa(
                                      _controllerPesquisa.text, orderBy);
                                });
                              },
                              icon: Icon(
                                Icons.search,
                                color: Colors.green,
                              ))),
                    ),
                  ),
                ),
              ),
              preferredSize: Size.fromHeight(80.0),
            ),
            title: Image.asset(
              "assets/img/logo.png",
              width: 100,
              height: 50,
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    enviaPesquisa(
                        _controllerPesquisa.text.length > 1
                            ? _controllerPesquisa.text
                            : "",
                        orderBy);
                  });
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.pushNamed(context, "/login");
                  });
                },
                icon: Icon(
                  Icons.person,
                  color: Colors.green,
                ),
              ),
            ],
            backgroundColor: Colors.black,
          ),
          floatingActionButton: HawkFabMenu(
            body: const Center(
              child: null,
            ),
            icon: AnimatedIcons.view_list,
            fabColor: Colors.green,
            iconColor: Colors.white,
            items: [
              HawkFabMenuItem(
                label: 'Ler Cód. barras',
                ontap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pushNamed(context, "/barCodeSimples");
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Menu 1 selected')),
                  // );
                },
                icon: Icon(Icons.camera_alt_outlined),
                color: Colors.green,
                labelColor: Colors.black,
                labelBackgroundColor: Colors.white,
              ),
              HawkFabMenuItem(
                label: 'Ler QR Code',
                ontap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pushNamed(context, "/scan");
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Menu 2 selected')),
                  // );
                },
                icon: const Icon(Icons.qr_code),
                color: Colors.green,
                labelColor: Colors.black,
                labelBackgroundColor: Colors.white,
              ),
              HawkFabMenuItem(
                label: 'Cód. Barras Duplo',
                ontap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pushNamed(context, "/barCode");
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Menu 3 selected')),
                  // );
                },
                icon: const Icon(Icons.add_a_photo_outlined),
                color: Colors.green,
                labelColor: Colors.black,
                labelBackgroundColor: Colors.white,
              ),
              HawkFabMenuItem(
                label: 'Digitar Cód. Barras',
                ontap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  Navigator.pushNamed(context, "/digitarCodigo");
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text('Menu 3 selected')),
                  // );
                },
                icon: const Icon(Icons.keyboard),
                color: Colors.green,
                labelColor: Colors.black,
                labelBackgroundColor: Colors.white,
              ),
            ],
          ),
          backgroundColor: Colors.white24.withOpacity(0.9),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: Colors.green.shade700,
                  ),
                  width: double.infinity,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 90, bottom: 20),
                  width: 299,
                  height: 279,
                  decoration: BoxDecoration(
                      color: Colors.green.shade400,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(160),
                          bottomLeft: Radius.circular(290),
                          bottomRight: Radius.circular(160),
                          topRight: Radius.circular(10))),
                ),
                CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      orderBy = "1";
                                      enviaPesquisa(
                                          _controllerPesquisa.text.length > 1
                                              ? _controllerPesquisa.text
                                              : "",
                                          orderBy);
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.filter_alt,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          "Preço",
                                          style: GoogleFonts.lato(
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      orderBy = "0";
                                      enviaPesquisa(
                                          _controllerPesquisa.text.length > 1
                                              ? _controllerPesquisa.text
                                              : "",
                                          orderBy);
                                    });
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.3,
                                    height: 40,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.filter_alt,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          "Data",
                                          style: GoogleFonts.lato(
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: FutureBuilder(
                                future: enviaPesquisa(
                                    _controllerPesquisa.text.length > 1
                                        ? _controllerPesquisa.text
                                        : "",
                                    orderBy),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.data.length > 0) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: GestureDetector(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 110,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                6,
                                                            height: 70,
                                                            child: Center(
                                                              child:
                                                                  Image.asset(
                                                                "assets/produto/produtoIcone.png",
                                                                width: 40,
                                                                height: 40,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.6,
                                                            height: 70,
                                                            child: Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 8.0,
                                                                      top: 8),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        snapshot.data[index].company!.name !=
                                                                                null
                                                                            ? snapshot.data[index].company!.name.toString().length > 31
                                                                                ? snapshot.data[index].company!.name.toString().substring(0, 31) + "..."
                                                                                : snapshot.data[index].company!.name
                                                                            : //snapshot.data[index].name
                                                                            "Não reconhecido",
                                                                        style: GoogleFonts.lato(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.green),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              8),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                8.0,
                                                                            bottom:
                                                                                8.0),
                                                                        child:
                                                                            Text(
                                                                          "R\$ ",
                                                                          style: GoogleFonts.lato(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.blue),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        snapshot.data[index].value.toString() !=
                                                                                ""
                                                                            ? snapshot.data[index].value!.toStringAsFixed(2).replaceAll(".",
                                                                                ",")
                                                                            : "Não encontrado",
                                                                        style: GoogleFonts.lato(
                                                                            fontSize:
                                                                                18,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.blue),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        snapshot.data[index].name !=
                                                                                null
                                                                            ? snapshot.data[index].name.toString().length > 31
                                                                                ? snapshot.data[index].name.toString().substring(0, 31) + "..."
                                                                                : snapshot.data[index].name
                                                                            : //snapshot.data[index].name
                                                                            "Não reconhecido",
                                                                        style: GoogleFonts.lato(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color(
                                                                    0xFFF1F8E9),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          16),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          16),
                                                                )),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 8.0),
                                                                child: Text(
                                                                  snapshot.data[index].date !=
                                                                          null
                                                                      ? _formataDataHora(
                                                                          snapshot
                                                                              .data[index]
                                                                              .date)
                                                                      : "Não encontrado",
                                                                  style: GoogleFonts
                                                                      .lato(
                                                                          fontSize:
                                                                              12),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 70,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                                  children: [
                                                                    Icon(Icons.star),
                                                                    Icon(Icons.add_shopping_cart)
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16),
                                                      // border: Border.all(
                                                      //   style: BorderStyle.solid,
                                                      //   color: Colors.white24
                                                      // ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.10),
                                                          spreadRadius: 10,
                                                          blurRadius: 10,
                                                          offset: Offset(0,
                                                              10), // changes position of shadow
                                                        ),
                                                      ]),
                                                ),
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                      context, "/produto",
                                                      arguments:
                                                          snapshot.data[index]
                                                              as ItemPesquisa);
                                                }),
                                          );
                                        },
                                      );
                                    } else {
                                      return new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.perm_device_info,
                                            color: Colors.white,
                                          ),
                                          Center(
                                              child: Text(
                                            "Não encontramos resultados",
                                            style: GoogleFonts.lato(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ))
                                        ],
                                      );
                                    }
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    return new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Text(
                                                "Não encontramos resultados"))
                                      ],
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 100.0,
                  height: 70.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset('assets/img/logoApp.jpg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      "Quer os melhores preços? TahQui!",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                ListTile(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  leading: Icon(Icons.home, color: Colors.green),
                  title: Text(
                    'Início',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.favorite, color: Colors.green),
                  title: Text(
                    'Favoritos',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                ListTile(
                  onTap: () {
                    if (usuarioRetorno != null) {
                      Navigator.pushNamed(context, '/configuracao');
                    } else {
                      Navigator.pushNamed(context, '/login');
                    }
                  },
                  leading: Icon(Icons.settings, color: Colors.green),
                  title: Text(
                    'Configuração',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                ListTile(
                  onTap: () {
                    logoutApp();
                  },
                  leading: Icon(Icons.logout, color: Colors.green),
                  title: Text(
                    'Sair',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}

class listaCirculo extends StatelessWidget {
  IconData icone;
  String titulo;
  listaCirculo(this.icone, this.titulo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              width: 60,
              height: 60,
              child: Center(
                child: Icon(this.icone),
              ),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
            ),
            Text(
              this.titulo,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
