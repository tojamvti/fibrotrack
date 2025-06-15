// lib/constants/pain_options.dart

const List<String> painLocations = [
  'Głowa',
  'Szyja',
  'Plecy',
  'Kręgosłup',
  'Ręka',
  'Noga',
  'Brzuch',
  'Stawy',
  
];

const List<String> painCharacters = [
  'Kłujący',
  'Pulsujący',
  'Palący',
  'Tępy',
  'Promieniujący',
  'Naciskowy',
  
];

const Map<String, List<String>> subPainLocations = {
  'Ręka': ['Prawa', 'Lewa'],
  'Noga': ['Prawa', 'Lewa'],
  'Brzuch': ['Prawa strona', 'Lewa strona', 'Środek'],
  'Stawy': ['Kolano', 'Łokieć', 'Nadgarstek', 'Biodro'],
};