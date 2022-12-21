
class StateService {
  static final List<String> states = [
    'ÎLES ANDAMAN ET NICOBAR',
    'ANDHRA PRADESH',
    'ARUNACHAL PRADESH',
    'ASSAM',
    'BIHAR',
    'CHATTISGARH',
    'CHANDIGAR',
    'DAMAN ET DIU',
    ' DELHI ',
    'DADRA ET NAGAR HAVELI',
    'GOA',
    'GUJARA',
    'HIMACHAL PRADESH',
    'HARYANE',
    'JAMMU-ET-CACHEMIRE',
    'JHARKHAND',
    'Kérala',
    'KARNATAKA',
    'LAKSHADWEEP',
    'MEGHALAYA',
    'MAHARASHTRA',
    'MANIPUR',
    'MADHYA PRADESH',
    'MIZORAM',
    'Nagaland',
    'ORISSA',
    'PUNJAB',
    'PONDICHERY',
    'RAJASTHAN',
    'SIKKIM',
    'TAMIL NADU',
    'TRIPURA',
    'OUTTARAKHAND',
    'UTTAR PRADESH',
    'BENGALE OCCIDENTAL',
    'TELANGANA',
    'LADAKH'
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
