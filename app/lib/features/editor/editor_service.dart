// Fix text + simple table. No internet. Originals kept.
class TextDoc {
  List<String> lines;
  TextDoc(this.lines);
  void setLine(int i, String v) {
    if (i >= 0 && i < lines.length) lines[i] = v;
  }
}

class TableDoc {
  List<List<String>> rows;
  TableDoc(this.rows);
  void setCell(int r, int c, String v) {
    if (r >= 0 && r < rows.length && c >= 0 && c < rows[r].length) {
      rows[r][c] = v;
    }
  }

  void addRow(List<String> row) => rows.add(row);
  void addCol(String head) {
    for (var i = 0; i < rows.length; i++) {
      rows[i].add(i == 0 ? head : '');
    }
  }
}
