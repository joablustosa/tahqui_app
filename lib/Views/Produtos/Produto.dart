import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../Models/ItemPesquisa.dart';

class Produto extends StatefulWidget {
  ItemPesquisa item;
  Produto(this.item);

  @override
  _ProdutoState createState() => _ProdutoState();
}

class _ProdutoState extends State<Produto>  {
  final TextStyle bold = TextStyle(fontWeight: FontWeight.bold);
  Completer<GoogleMapController> _controller = Completer();
  double latitude = 0;
  double longitude = 0;
  Set<Marker>? marcador;

  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  _formataDataHora(data){
    var t = DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(data));
    return t.toString();
  }

  recuperarLocalParaEndereco(String endereco) async {
    List<Location> locations = await locationFromAddress(endereco);

    // print(widget.item.company!.address!.street.toString()+" "+
    //     widget.item.company!.address!.number! + ", " + widget.item.company!.address!.city!.name!);
    if( locations != null && locations.length > 0){
      Location endereco = locations[0];
      setState(() {
        latitude = endereco.latitude;
        longitude = endereco.longitude;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperarLocalParaEndereco(
        widget.item.company!.address!.street.toString()+" "+
        widget.item.company!.address!.number! + ", " + widget.item.company!.address!.city!.name!
    );
    _marcadores();
  }

  _marcadores() {
    Set<Marker> marcadorLocal = {};
    Marker marcadorLoja = Marker(
      markerId: MarkerId("marcador-loja"),
      position: LatLng(latitude,longitude)
    );
    marcadorLocal.add(marcadorLoja);

    setState(() {
      marcador = marcadorLocal;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.green,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Image.asset("assets/img/logo.png",
          width: 50,
          height: 50,
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                        child: Text(
                          "Informações",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(widget.item.name!),
                          subtitle: Text(_formataDataHora(widget.item.date!)),
                          leading: Text(
                            "R\$ " + widget.item.value!.toStringAsFixed(2).replaceAll(".", ","),
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.green
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                      //   child: Text(
                      //     "Dados Envio",
                      //     style: Theme.of(context).textTheme.titleMedium,
                      //   ),
                      // ),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: <Widget>[
                      //       CardPersonalizado(
                      //         label: "Data",
                      //         value: "03/04/20",
                      //         icon: Icon(
                      //           Icons.calendar_today,
                      //         ),
                      //       ),
                      //       CardPersonalizado(
                      //         label: "Usuário",
                      //         value: "@joabLustosa",
                      //         icon: Icon(
                      //           Icons.apps,
                      //         ),
                      //       ),
                      //       CardPersonalizado(
                      //         label: "Encontrados",
                      //         value: "15 Itens",
                      //         icon: Icon(
                      //           Icons.pageview_rounded,
                      //         ),
                      //       ),
                      //       CardPersonalizado(
                      //         label: "Compartilhar",
                      //         value: "Item",
                      //         icon: Icon(
                      //           Icons.share,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                        child: Text(
                          "Mercado",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                        child: Text(
                            widget.item.company!.name! != "" ?
                            widget.item.company!.name! :
                            "Não encontrado",
                          style: GoogleFonts.lato(
                            color: Colors.green,
                            fontSize: 16
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                        child: Text(
                          "Localização",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                        child: Text(
                            widget.item.company!.address!.street != "" ?
                            widget.item.company!.address!.street! + ", " +
                            widget.item.company!.address!.number! + " - " +
                            widget.item.company!.address!.city!.name! :
                            "Não encontrado",
                          style: GoogleFonts.lato(
                            color: Colors.green,
                            fontSize: 16
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          //-3.7720856,-38.5594791
                          initialCameraPosition: CameraPosition(
                            target: LatLng(latitude,longitude),
                            zoom: 16,
                          ),
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          onMapCreated: _onMapCreated,
                          markers: marcador!,
                        ),
                      )
                      // const SizedBox(height: 20.0),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                      //   child: Text(
                      //     "Mercados Próximos",
                      //     style: Theme.of(context).textTheme.titleMedium,
                      //   ),
                      // ),
                      // ContainerPersonalizado(
                      //   padding: const EdgeInsets.all(0),
                      //   margin: const EdgeInsets.symmetric(vertical: 4.0),
                      //   child: ListTile(
                      //     title: Text("Mercado 1"),
                      //     trailing: Text(
                      //       "R\$: 1,00",
                      //       style: bold,
                      //     ),
                      //   ),
                      // ),
                      // ContainerPersonalizado(
                      //   padding: const EdgeInsets.all(0),
                      //   margin: const EdgeInsets.symmetric(vertical: 4.0),
                      //   child: ListTile(
                      //     title: Text("Mercado 2"),
                      //     trailing: Text(
                      //       "R\$: 2,00",
                      //       style: bold,
                      //     ),
                      //   ),
                      // ),
                      // ContainerPersonalizado(
                      //   padding: const EdgeInsets.all(0),
                      //   margin: const EdgeInsets.symmetric(vertical: 4.0),
                      //   child: ListTile(
                      //     title: Text("Mercado 3"),
                      //     trailing: Text(
                      //       "R\$: 3,00",
                      //       style: bold,
                      //     ),
                      //   ),
                      // ),
                      // ContainerPersonalizado(
                      //   margin: const EdgeInsets.symmetric(vertical: 4.0),
                      //   padding: const EdgeInsets.all(0),
                      //   child: ListTile(
                      //     title: Text("Mercado 4"),
                      //     trailing: Text(
                      //       "R\$: 4,00",
                      //       style: bold,
                      //     ),
                      //   ),
                      // ),
                      // ContainerPersonalizado(
                      //   margin: const EdgeInsets.symmetric(
                      //     vertical: 4.0,
                      //   ),
                      //   padding: const EdgeInsets.all(0),
                      //   child: ListTile(
                      //     title: Text("Mercado 5"),
                      //     trailing: Text(
                      //       "R\$: 5,00",
                      //       style: bold,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: RaisedButton.icon(
          //     color: Theme.of(context).accentColor,
          //     textColor: Colors.white,
          //     icon: Icon(Icons.message),
          //     label: Text("Reserva"),
          //     onPressed: () {},
          //   ),
          // )
        ],
      ),
    );
  }
}

class ContainerPersonalizado extends StatelessWidget {
  final String? title;
  final Widget? child;
  final double? height;
  final double width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double elevation;

  const ContainerPersonalizado({
    Key? key,
    this.title,
    this.child,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.width = double.infinity,
    this.elevation = 0.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      margin: margin ?? const EdgeInsets.all(0),
      child: Container(
        padding: padding ?? const EdgeInsets.all(16.0),
        width: width,
        height: height,
        child: title == null
            ? child
            : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title!,
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
            ),
            if (child != null) ...[
              const SizedBox(height: 10.0),
              child!,
            ]
          ],
        ),
      ),
    );
  }
}

class CardPersonalizado extends StatelessWidget {
  const CardPersonalizado({
    Key? key,
    this.icon,
    this.label,
    this.value,
  }) : super(key: key);

  final Widget? icon;
  final String? label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            if (icon != null) icon!,
            const SizedBox(height: 2.0),
            Text(
              label!,
              style: TextStyle(
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              value!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}