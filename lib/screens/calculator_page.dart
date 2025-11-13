// lib/screens/calculator_page.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({super.key});
  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expr = '';
  String _result = '0';

  // =================== EVALUATOR ===================
  double _eval(String input) {
    var s = input
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('%', '%')
        .replaceAll(' ', '');

    final outputQueue = <String>[];
    final opStack = <String>[];
    final tokens = _tokenize(s);

    int prec(String op) {
      switch (op) {
        case 'sqrt':
        case 'pow2':
          return 4;
        case '*':
        case '/':
          return 3;
        case '+':
        case '-':
          return 2;
        default:
          return 0;
      }
    }

    bool isOp(String t) => ['+', '-', '*', '/', 'sqrt', 'pow2'].contains(t);

    for (final t in tokens) {
      if (_isNumber(t)) {
        outputQueue.add(t);
      } else if (t == 'sqrt' || t == 'pow2') {
        opStack.add(t);
      } else if (isOp(t)) {
        while (opStack.isNotEmpty &&
            isOp(opStack.last) &&
            prec(opStack.last) >= prec(t)) {
          outputQueue.add(opStack.removeLast());
        }
        opStack.add(t);
      } else if (t == '(') {
        opStack.add(t);
      } else if (t == ')') {
        while (opStack.isNotEmpty && opStack.last != '(') {
          outputQueue.add(opStack.removeLast());
        }
        if (opStack.isNotEmpty && opStack.last == '(') opStack.removeLast();
        if (opStack.isNotEmpty &&
            (opStack.last == 'sqrt' || opStack.last == 'pow2')) {
          outputQueue.add(opStack.removeLast());
        }
      } else if (t == '%') {
        outputQueue.add('0.01');
        while (opStack.isNotEmpty &&
            isOp(opStack.last) &&
            prec(opStack.last) >= prec('*')) {
          outputQueue.add(opStack.removeLast());
        }
        opStack.add('*');
      }
    }
    while (opStack.isNotEmpty) {
      final op = opStack.removeLast();
      if (op == '(' || op == ')') throw Exception('Parenthesis mismatch');
      outputQueue.add(op);
    }

    final st = <double>[];
    for (final t in outputQueue) {
      if (_isNumber(t)) {
        st.add(double.parse(t));
      } else {
        switch (t) {
          case '+':
            _bin(st, (a, b) => a + b);
            break;
          case '-':
            _bin(st, (a, b) => a - b);
            break;
          case '*':
            _bin(st, (a, b) => a * b);
            break;
          case '/':
            _bin(st, (a, b) => a / b);
            break;
          case 'sqrt':
            if (st.isEmpty) throw Exception('sqrt arg');
            final x = st.removeLast();
            st.add(x < 0 ? double.nan : math.sqrt(x));
            break;
          case 'pow2':
            if (st.isEmpty) throw Exception('pow2 arg');
            final x = st.removeLast();
            st.add(x * x);
            break;
          default:
            throw Exception('unknown token $t');
        }
      }
    }
    if (st.length != 1) throw Exception('bad expression');
    return st.single;
  }

  void _bin(List<double> st, double Function(double, double) f) {
    if (st.length < 2) throw Exception('arg');
    final b = st.removeLast();
    final a = st.removeLast();
    st.add(f(a, b));
  }

  bool _isNumber(String t) => RegExp(r'^-?\d+(\.\d+)?$').hasMatch(t);

  List<String> _tokenize(String s) {
    final tokens = <String>[];
    int i = 0;
    while (i < s.length) {
      final ch = s[i];
      if ('0123456789.'.contains(ch)) {
        final start = i;
        i++;
        while (i < s.length && '0123456789.'.contains(s[i])) i++;
        tokens.add(s.substring(start, i));
        continue;
      }
      if ('()+-*/%'.contains(ch)) {
        tokens.add(ch);
        i++;
        continue;
      }
      if (s.startsWith('sqrt', i)) {
        tokens.add('sqrt');
        i += 4;
        continue;
      }
      if (s.startsWith('pow2', i)) {
        tokens.add('pow2');
        i += 4;
        continue;
      }
      if (ch == ' ') {
        i++;
        continue;
      }
      throw Exception('bad char: $ch');
    }
    return tokens;
  }

  // =================== STATE UPDATERS ===================
  void _append(String t) {
    setState(() {
      if (_expr.isEmpty && (t == '+' || t == '×' || t == '÷')) return;
      _expr += t;
      _tryEval();
    });
  }

  void _clear() => setState(() {
    _expr = '';
    _result = '0';
  });

  void _backspace() {
    if (_expr.isEmpty) return;
    setState(() {
      _expr = _expr.substring(0, _expr.length - 1);
      _tryEval();
    });
  }

  void _wrapWith(String funcName) {
    if (_expr.isEmpty) return;
    final end = _expr.length - 1;
    int start = end;
    int depth = 0;
    if (_expr[end] == ')') {
      depth = 1;
      start--;
      while (start >= 0) {
        if (_expr[start] == ')') depth++;
        if (_expr[start] == '(') {
          depth--;
          if (depth == 0) break;
        }
        start--;
      }
    } else {
      while (start >= 0 && RegExp(r'[\d.]').hasMatch(_expr[start])) start--;
      start++;
    }
    if (start < 0) start = 0;

    final left = _expr.substring(0, start);
    final term = _expr.substring(start);
    setState(() {
      _expr = left + '$funcName($term)';
      _tryEval();
    });
  }

  void _tryEval() {
    try {
      final v = _eval(_expr);
      _result = (v.isNaN || v.isInfinite) ? 'Error' : _format(v);
    } catch (_) {
      _result = '…';
    }
  }

  String _format(double v) {
    final s = v.toStringAsFixed(10);
    return s.contains('.') ? s.replaceFirst(RegExp(r'\.?0+$'), '') : s;
  }

  // =================== PRETTY-PRINT (TAMPILAN MATEMATIKA) ===================
  // Ubah "sqrt(3+pow2(5))" -> "√(3+(5)²)" untuk ditampilkan.
  String _pretty(String s) {
    int i = 0;
    final buf = StringBuffer();

    int _matchParen(String text, int openIdx) {
      // openIdx menunjuk '('
      int depth = 1, j = openIdx + 1;
      while (j < text.length && depth > 0) {
        if (text[j] == '(') depth++;
        if (text[j] == ')') depth--;
        j++;
      }
      return (depth == 0) ? j - 1 : -1; // index ')'
    }

    while (i < s.length) {
      // sqrt( ... )
      if (s.startsWith('sqrt(', i)) {
        final open = i + 4; // index '('
        final close = _matchParen(s, open);
        if (close == -1) {
          // fallback kalau salah kurung
          buf.write('√(');
          i += 5;
          continue;
        }
        final inner = s.substring(open + 1, close);
        buf.write('√(');
        buf.write(_pretty(inner));
        buf.write(')');
        i = close + 1;
        continue;
      }
      // pow2( ... )
      if (s.startsWith('pow2(', i)) {
        final open = i + 4;
        final close = _matchParen(s, open);
        if (close == -1) {
          buf.write('(');
          i += 5;
          continue;
        }
        final inner = s.substring(open + 1, close);
        buf.write('(');
        buf.write(_pretty(inner));
        buf.write(')\u00B2'); // superscript 2
        i = close + 1;
        continue;
      }

      // operators untuk tampilan (jaga × dan ÷ tetap)
      if (s[i] == '*') {
        buf.write('×');
        i++;
        continue;
      }
      if (s[i] == '/') {
        buf.write('÷');
        i++;
        continue;
      }

      // karakter lain (angka, +, -, %, titik, (), spasi)
      buf.write(s[i]);
      i++;
    }
    return buf.toString();
  }

  // =================== UI ===================
  @override
  Widget build(BuildContext context) {
    final green = (AppColors.oliveMist);
    final soft = (AppColors.creamy);
    final opPink = (AppColors.blush);
    const peachAC = Color(0xFFF9D0CE);
    const dotBg = Color(0xFFF89CAB);

    final exprStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.black87,
    );
    final resultStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w900,
      color: Colors.black87,
    );
    const btnText = TextStyle(fontWeight: FontWeight.w800, fontSize: 24);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                // Header bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x14000000)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _RoundedBackButton(
                          color: green,
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/dashboard',
                                (route) => false,
                              );
                            }
                          },
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Calculator',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Display
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7D6C7),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0x22000000)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: Text(
                          _expr.isEmpty ? '0' : _pretty(_expr),
                          style: exprStyle,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(height: 1.2, color: const Color(0x22000000)),
                      const SizedBox(height: 16),
                      Text(_result, style: resultStyle),
                    ],
                  ),
                ),

                // Mini function buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _mini('√', () => _wrapWith('sqrt')),
                      _mini('(', () => _append('(')),
                      _mini(')', () => _append(')')),
                      _mini('%', () => _append('%')),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Keypad
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: LayoutBuilder(
                    builder: (ctx, c) {
                      const hgap = 8.0;
                      const vgap = 10.0;
                      final d = math.min((c.maxWidth - 3 * hgap) / 4, 75.0);

                      return Column(
                        children: [
                          _row(d, hgap, [
                            _btn(
                              'AC',
                              onTap: _clear,
                              bg: peachAC,
                              txt: btnText,
                            ),
                            _btn(
                              'x²',
                              onTap: () => _wrapWith('pow2'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '÷',
                              onTap: () => _append('÷'),
                              bg: opPink,
                              txt: btnText,
                            ),
                            _btn(
                              '⌫',
                              onTap: _backspace,
                              bg: soft,
                              txt: btnText,
                            ),
                          ]),
                          const SizedBox(height: vgap),
                          _row(d, hgap, [
                            _btn(
                              '7',
                              onTap: () => _append('7'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '8',
                              onTap: () => _append('8'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '9',
                              onTap: () => _append('9'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '×',
                              onTap: () => _append('×'),
                              bg: opPink,
                              txt: btnText,
                            ),
                          ]),
                          const SizedBox(height: vgap),
                          _row(d, hgap, [
                            _btn(
                              '4',
                              onTap: () => _append('4'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '5',
                              onTap: () => _append('5'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '6',
                              onTap: () => _append('6'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '-',
                              onTap: () => _append('-'),
                              bg: opPink,
                              txt: btnText,
                            ),
                          ]),
                          const SizedBox(height: vgap),
                          _row(d, hgap, [
                            _btn(
                              '1',
                              onTap: () => _append('1'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '2',
                              onTap: () => _append('2'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '3',
                              onTap: () => _append('3'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '+',
                              onTap: () => _append('+'),
                              bg: opPink,
                              txt: btnText,
                            ),
                          ]),
                          const SizedBox(height: vgap),
                          _row(d, hgap, [
                            _btn(
                              '0',
                              onTap: () => _append('0'),
                              bg: soft,
                              txt: btnText,
                            ),
                            _btn(
                              '.',
                              onTap: () => _append('.'),
                              bg: dotBg,
                              txt: btnText,
                            ),
                            _btn(
                              '=',
                              onTap: () {
                                try {
                                  setState(
                                    () => _result = _format(_eval(_expr)),
                                  );
                                } catch (_) {
                                  setState(() => _result = 'Error');
                                }
                              },
                              bg: green,
                              txt: btnText,
                            ),
                            const SizedBox.shrink(),
                          ]),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =================== UI HELPERS ===================
  Row _row(double d, double hgap, List<Widget> children) {
    final items = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      items.add(SizedBox(width: d, height: d, child: children[i]));
      if (i != children.length - 1) items.add(SizedBox(width: hgap));
    }
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: items);
  }

  Widget _btn(
    String label, {
    required VoidCallback onTap,
    required Color bg,
    required TextStyle txt,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bg,
        shape: const CircleBorder(),
        foregroundColor: Colors.black87,
        textStyle: txt,
        padding: EdgeInsets.zero,
      ),
      child: Text(label),
    );
  }

  Widget _mini(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0x33000000), width: 1),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _RoundedBackButton extends StatelessWidget {
  const _RoundedBackButton({required this.onTap, required this.color});
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: Colors.white.withOpacity(.25),
        highlightColor: Colors.white.withOpacity(.15),
        child: const SizedBox(
          width: 36,
          height: 36,
          child: Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}
