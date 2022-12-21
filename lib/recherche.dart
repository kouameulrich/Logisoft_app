// import 'package:flutter/material.dart';
// import 'package:gs_rest/models/charge.dart';
// import 'package:gs_rest/providers/data_provider.dart';
// import 'package:gs_rest/utils/my_colors.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
//
// class ChargeScreen extends StatefulWidget {
//
//   @override
//   State<ChargeScreen> createState() => _ChargeScreenState();
// }
//
// class _ChargeScreenState extends State<ChargeScreen> {
//
//   TextEditingController? _searchController = TextEditingController();
//   String _searchValue = "";
//   List<Charge>? charges = [];
//   List<Charge>? filterCharges = [];
//
//   @override
//   void initState() {
//     charges = Provider.of<DataProvider>(context, listen: false).charge;
//     filterCharges = charges;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final charges = Provider.of<DataProvider>(context, listen: false).charge;
//
//     filterCharges!.sort(
//             (a, b) => b.date!.compareTo(
//             a.date!
//         )
//     );
//
//     return Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           title: Text(
//               "Charges"
//           ),
//         ),
//
//         body: ListView(
//
//           children: [
//             SizedBox(height: 20,),
//
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 12),
//               alignment: Alignment.centerLeft,
//               child: TextFormField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                     hintText: "Rechercher..."
//                 ),
//
//                 onChanged: (value) {
//                   print(value);
//                   setState(() {
//                     _searchValue = value;
//                     filterCharges = charges!.where(
//                             (element) => element.chargeLibelle!.libelle.toString().contains(_searchValue)
//                             || DateFormat('dd/MM/yyyy').format(element.date!).contains(_searchValue)
//                             || element.montant.toString().contains(_searchValue)
//                             || element.type.toString().contains(_searchValue.toUpperCase())
//                     ).toList();
//                   });
//                 },
//               ),
//             ),
//
//             SingleChildScrollView(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width,
//
//                   child: DataTable(
//                       horizontalMargin: 10,
//                       columnSpacing: 15,
//                       showBottomBorder: true,
//                       headingRowHeight: 45,
//                       headingRowColor: MaterialStateColor.resolveWith(
//                             (states) {
//                           return MyColors.primary.withOpacity(0.3);
//                         },
//                       ),
//                       columns: [
//                         buildDataColumn('Date'),
//                         buildDataColumn('Libelle'),
//                         buildDataColumn('Montant'),
//                         buildDataColumn('Type'),
//
//                       ],
//
//                       rows: filterCharges != null ? filterCharges!.map(
//                               (ch) => buildRow(
//                             ch.date!,
//                             ch.chargeLibelle!.libelle!,
//                             ch.montant!,
//                             ch.type!,
//                             //observation
//                           )
//                       ).toList() : []
//
//                     // rows:  recettes!.asMap().map(
//                     //   (i, rec) => MapEntry(
//                     //     i, buildRow(
//                     //      rec.date!,
//                     //      rec.lebelle!,
//                     //      rec.montant!,
//                     //       index: i
//                     //     )
//                     //   )
//                     // ).values.toList()
//
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         )
//     );
//   }
//
//   DataColumn buildDataColumn(String label) {
//     return DataColumn(
//         label: Text(
//           label,
//           style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold
//           ),
//         )
//     );
//   }
//
//   DataRow buildRow(DateTime date, String libelle, int montant, String type, {int? index}) {
//     return DataRow(
//       // color: (index! % 2 == 0 )
//       // ? MaterialStateColor.resolveWith(
//       //   (states) {
//       //     return MyColors.primary.withOpacity(0.1);
//       //   },
//       // )
//       // : MaterialStateColor.resolveWith(
//       //   (states) {
//       //     return MyColors.white;
//       //   },
//       // ),
//
//         cells: [
//           DataCell(Text(DateFormat('dd/MM/yyyy').format(date),)),
//
//           DataCell(
//               Text(libelle)
//           ),
//
//           DataCell(
//               Text(
//                 "${NumberFormat.currency(locale: "eu", symbol: 'F', decimalDigits: 0).format(montant)}" ,
//                 // style:TextStyle(fontWeight: FontWeight.bold),
//               )
//           ),
//
//           DataCell(
//               Chip(
//                   padding: EdgeInsets.zero,
//                   backgroundColor: type == "CHARGE" ? Colors.pink.withOpacity(0.7) :  Colors.orange.withOpacity(0.7),
//                   label: Text(type, style: TextStyle(color: MyColors.white, fontSize: 10),)
//               )
//           ),
//
//
//         ]
//     );
//   }
// }