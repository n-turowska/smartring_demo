import 'package:smartring_demo/histogram/pojedynczy_slupek.dart';

class HistogramDane {
  final double ponLiczba;
  final double wtLiczba;
  final double srLiczba;
  final double czwLiczba;
  final double ptLiczba;
  final double sobLiczba;
  final double niedzLiczba;

  HistogramDane({
    required this.ponLiczba,
    required this.wtLiczba,
    required this.srLiczba,
    required this.czwLiczba,
    required this.ptLiczba,
    required this.sobLiczba,
    required this.niedzLiczba,
    });

    List<PojedynczySlupek> histogramDane = [];

    void initializeHistogramDane() {
      histogramDane = [
        PojedynczySlupek(x: 0, y: ponLiczba),
        PojedynczySlupek(x: 1, y: wtLiczba),
        PojedynczySlupek(x: 2, y: srLiczba),
        PojedynczySlupek(x: 3, y: czwLiczba),
        PojedynczySlupek(x: 4, y: ptLiczba),
        PojedynczySlupek(x: 5, y: sobLiczba),
        PojedynczySlupek(x: 6, y: niedzLiczba),
      ];
    }

}