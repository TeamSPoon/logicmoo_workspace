/* Generated By:JavaCC: Do not edit this line. InterpretationParser.java */
package net.sf.regulus.interpretation;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Hashtable;
import java.io.PrintStream;


        public class InterpretationParser implements InterpretationParserConstants {

                public class KVPair{
                        String key;
                        Object val;

                        KVPair(String key, Object val){
                                this.key = key;
                                this.val = val;
                        }

                        String getKey(){
                                return key;
                        }

                        Object getVal(){
                                return val;
                        }


                }

                static PrintStream outStream = null;


                public static void main( String[] args ) throws ParseException, TokenMgrError {
                        outStream = System.out;
                        InterpretationParser parser = new InterpretationParser( System.in ) ;
                        parser.enable_tracing();
                        parser.start() ;
                }

  final public String identifier() throws ParseException {
    trace_call("identifier");
    try {
        Token t;
      if (jj_2_1(5)) {
        t = jj_consume_token(ID);
                {if (true) return t.image;}
      } else if (jj_2_2(5)) {
        jj_consume_token(SINGLE_QUOTE);
        t = jj_consume_token(ID);
        jj_consume_token(SINGLE_QUOTE);
                                            {if (true) return t.image;}
      } else if (jj_2_3(5)) {
        t = jj_consume_token(INT);
                 {if (true) return t.image;}
      } else {
        jj_consume_token(-1);
        throw new ParseException();
      }
    throw new Error("Missing return statement in function");
    } finally {
      trace_return("identifier");
    }
  }

  final public KVPair keyValuePair() throws ParseException {
    trace_call("keyValuePair");
    try {
        String key = null;
        String value = null;
        Object objectVal = null;
        Token num = null;
      key = identifier();
      jj_consume_token(SEP);
      if (jj_2_4(5)) {
        value = identifier();
      } else if (jj_2_5(5)) {
        num = jj_consume_token(INT);
      } else if (jj_2_6(5)) {
        objectVal = array();
      } else if (jj_2_7(5)) {
        objectVal = keyValuePairs();
      } else {
        jj_consume_token(-1);
        throw new ParseException();
      }
                Object retValue;
                if ( value != null ) {
                        retValue = value;
                }
                else if(num != null) {
                        retValue = num.image;
                }
                else if(objectVal != null){
                        retValue = objectVal;
                }
                else {
                        retValue = null;
                }

                debug("adding " + key);

                KVPair result = new KVPair(key, retValue);
                {if (true) return result;}
    throw new Error("Missing return statement in function");
    } finally {
      trace_return("keyValuePair");
    }
  }

//
// 'spec', =, 2, 'noun', =, 'cat'
//
  final public Hashtable keyValuePairList() throws ParseException {
    trace_call("keyValuePairList");
    try {
        Hashtable result = null;
        Object o;
        KVPair kv;
                result = new Hashtable();
      kv = keyValuePair();
                                  result.put(kv.getKey(), kv.getVal());
      label_1:
      while (true) {
        if (jj_2_8(5)) {
          ;
        } else {
          break label_1;
        }
        jj_consume_token(COMMA);
        kv = keyValuePair();
                        result.put(kv.getKey(), kv.getVal());
      }
                {if (true) return result;}
    throw new Error("Missing return statement in function");
    } finally {
      trace_return("keyValuePairList");
    }
  }

//
// '[ 'spec', =, 2, 'noun', =, 'cat' ]'
//
  final public Hashtable keyValuePairs() throws ParseException {
    trace_call("keyValuePairs");
    try {
        Hashtable result = null;
      //	(
      //	 <L_BRACKET> result=keyValuePairList() <R_BRACKET>
      //	 | result=keyValuePairList()
      //	)
              result = keyValuePairList();
                {if (true) return result;}
    throw new Error("Missing return statement in function");
    } finally {
      trace_return("keyValuePairs");
    }
  }

// '[ 'value', =, [ [ 'type', 'command' ], [ 'action', 'switch' ], [ 'onoff', 'off' ], [ 'device', 'light' ] ] ]'
// '[ 'value', =, [ 'spec', =, 2, 'noun', =, 'cat', 'toys', =,  ['a', 'b', 'c', 'd', 'e'] ] ]'
  final public Object arrayElement() throws ParseException {
    trace_call("arrayElement");
    try {
        Object newObject;
      if (jj_2_9(5)) {
        newObject = keyValuePairs();
      } else if (jj_2_10(5)) {
        newObject = array();
      } else if (jj_2_11(5)) {
        newObject = identifier();
      } else {
        jj_consume_token(-1);
        throw new ParseException();
      }
                {debug(" adding " + newObject); }
                {if (true) return newObject;}
    throw new Error("Missing return statement in function");
    } finally {
      trace_return("arrayElement");
    }
  }

  final public ArrayList arrayElementList() throws ParseException {
    trace_call("arrayElementList");
    try {
        ArrayList result = new ArrayList();
        Object newVal = null;
      newVal = arrayElement();
                                     result.add(newVal);
      label_2:
      while (true) {
        if (jj_2_12(5)) {
          ;
        } else {
          break label_2;
        }
        jj_consume_token(COMMA);
        newVal = arrayElement();
                                                                                            result.add(newVal);
      }
                {if (true) return(result);}
    throw new Error("Missing return statement in function");
    } finally {
      trace_return("arrayElementList");
    }
  }

//
//  [ [ 'type', 'command' ], [ 'action', 'switch' ], [ 'onoff', 'off' ], 'toys', =,  ['a', 'b', 'c', 'd', 'e'] ]
//
  final public ArrayList array() throws ParseException {
    trace_call("array");
    try {
        ArrayList result = null;
      jj_consume_token(L_BRACKET);
      result = arrayElementList();
      jj_consume_token(R_BRACKET);
                {if (true) return result;}
    throw new Error("Missing return statement in function");
    } finally {
      trace_return("array");
    }
  }

  final public ArrayList createInterpretation() throws ParseException {
    trace_call("createInterpretation");
    try {
        ArrayList result = null;
      if (jj_2_13(5)) {
        jj_consume_token(SINGLE_QUOTE);
        result = array();
        jj_consume_token(SINGLE_QUOTE);
      } else if (jj_2_14(5)) {
        result = array();
      } else {
        jj_consume_token(-1);
        throw new ParseException();
      }
                {if (true) return result;}
    throw new Error("Missing return statement in function");
    } finally {
      trace_return("createInterpretation");
    }
  }

  final public void start() throws ParseException {
    trace_call("start");
    try {
        ArrayList result;
                result = array();
    } finally {
      trace_return("start");
    }
  }

  final public void xstart() throws ParseException {
    trace_call("xstart");
    try {
        Hashtable result;
                result=keyValuePairs();
                Enumeration enumeration = result.keys();

                debug(result.size() + " ");

                for (; enumeration.hasMoreElements() ;) {
                        debug((String)enumeration.nextElement());
                }
    } finally {
      trace_return("xstart");
    }
  }

  final public void debug(String message) throws ParseException {
    trace_call("debug");
    try {
                if ( outStream != null){
                        outStream.println(message );
                }
    } finally {
      trace_return("debug");
    }
  }

  final private boolean jj_2_1(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_1(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(0, xla); }
  }

  final private boolean jj_2_2(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_2(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(1, xla); }
  }

  final private boolean jj_2_3(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_3(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(2, xla); }
  }

  final private boolean jj_2_4(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_4(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(3, xla); }
  }

  final private boolean jj_2_5(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_5(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(4, xla); }
  }

  final private boolean jj_2_6(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_6(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(5, xla); }
  }

  final private boolean jj_2_7(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_7(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(6, xla); }
  }

  final private boolean jj_2_8(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_8(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(7, xla); }
  }

  final private boolean jj_2_9(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_9(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(8, xla); }
  }

  final private boolean jj_2_10(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_10(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(9, xla); }
  }

  final private boolean jj_2_11(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_11(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(10, xla); }
  }

  final private boolean jj_2_12(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_12(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(11, xla); }
  }

  final private boolean jj_2_13(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_13(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(12, xla); }
  }

  final private boolean jj_2_14(int xla) {
    jj_la = xla; jj_lastpos = jj_scanpos = token;
    try { return !jj_3_14(); }
    catch(LookaheadSuccess ls) { return true; }
    finally { jj_save(13, xla); }
  }

  final private boolean jj_3R_8() {
    if (jj_3R_7()) return true;
    Token xsp;
    while (true) {
      xsp = jj_scanpos;
      if (jj_3_12()) { jj_scanpos = xsp; break; }
    }
    return false;
  }

  final private boolean jj_3_8() {
    if (jj_scan_token(COMMA)) return true;
    if (jj_3R_6()) return true;
    return false;
  }

  final private boolean jj_3_11() {
    if (jj_3R_3()) return true;
    return false;
  }

  final private boolean jj_3_10() {
    if (jj_3R_4()) return true;
    return false;
  }

  final private boolean jj_3R_6() {
    if (jj_3R_3()) return true;
    if (jj_scan_token(SEP)) return true;
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_4()) {
    jj_scanpos = xsp;
    if (jj_3_5()) {
    jj_scanpos = xsp;
    if (jj_3_6()) {
    jj_scanpos = xsp;
    if (jj_3_7()) return true;
    }
    }
    }
    return false;
  }

  final private boolean jj_3_9() {
    if (jj_3R_5()) return true;
    return false;
  }

  final private boolean jj_3_6() {
    if (jj_3R_4()) return true;
    return false;
  }

  final private boolean jj_3R_9() {
    if (jj_3R_6()) return true;
    Token xsp;
    while (true) {
      xsp = jj_scanpos;
      if (jj_3_8()) { jj_scanpos = xsp; break; }
    }
    return false;
  }

  final private boolean jj_3R_7() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_9()) {
    jj_scanpos = xsp;
    if (jj_3_10()) {
    jj_scanpos = xsp;
    if (jj_3_11()) return true;
    }
    }
    return false;
  }

  final private boolean jj_3_3() {
    if (jj_scan_token(INT)) return true;
    return false;
  }

  final private boolean jj_3_2() {
    if (jj_scan_token(SINGLE_QUOTE)) return true;
    if (jj_scan_token(ID)) return true;
    if (jj_scan_token(SINGLE_QUOTE)) return true;
    return false;
  }

  final private boolean jj_3_14() {
    if (jj_3R_4()) return true;
    return false;
  }

  final private boolean jj_3_4() {
    if (jj_3R_3()) return true;
    return false;
  }

  final private boolean jj_3_1() {
    if (jj_scan_token(ID)) return true;
    return false;
  }

  final private boolean jj_3R_3() {
    Token xsp;
    xsp = jj_scanpos;
    if (jj_3_1()) {
    jj_scanpos = xsp;
    if (jj_3_2()) {
    jj_scanpos = xsp;
    if (jj_3_3()) return true;
    }
    }
    return false;
  }

  final private boolean jj_3_13() {
    if (jj_scan_token(SINGLE_QUOTE)) return true;
    if (jj_3R_4()) return true;
    if (jj_scan_token(SINGLE_QUOTE)) return true;
    return false;
  }

  final private boolean jj_3_5() {
    if (jj_scan_token(INT)) return true;
    return false;
  }

  final private boolean jj_3R_5() {
    if (jj_3R_9()) return true;
    return false;
  }

  final private boolean jj_3R_4() {
    if (jj_scan_token(L_BRACKET)) return true;
    if (jj_3R_8()) return true;
    if (jj_scan_token(R_BRACKET)) return true;
    return false;
  }

  final private boolean jj_3_7() {
    if (jj_3R_5()) return true;
    return false;
  }

  final private boolean jj_3_12() {
    if (jj_scan_token(COMMA)) return true;
    if (jj_3R_7()) return true;
    return false;
  }

  public InterpretationParserTokenManager token_source;
  SimpleCharStream jj_input_stream;
  public Token token, jj_nt;
  private int jj_ntk;
  private Token jj_scanpos, jj_lastpos;
  private int jj_la;
  public boolean lookingAhead = false;
  private boolean jj_semLA;
  private int jj_gen;
  final private int[] jj_la1 = new int[0];
  static private int[] jj_la1_0;
  static {
      jj_la1_0();
   }
   private static void jj_la1_0() {
      jj_la1_0 = new int[] {};
   }
  final private JJCalls[] jj_2_rtns = new JJCalls[14];
  private boolean jj_rescan = false;
  private int jj_gc = 0;

  public InterpretationParser(java.io.InputStream stream) {
    jj_input_stream = new SimpleCharStream(stream, 1, 1);
    token_source = new InterpretationParserTokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public void ReInit(java.io.InputStream stream) {
    jj_input_stream.ReInit(stream, 1, 1);
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public InterpretationParser(java.io.Reader stream) {
    jj_input_stream = new SimpleCharStream(stream, 1, 1);
    token_source = new InterpretationParserTokenManager(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public void ReInit(java.io.Reader stream) {
    jj_input_stream.ReInit(stream, 1, 1);
    token_source.ReInit(jj_input_stream);
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public InterpretationParser(InterpretationParserTokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  public void ReInit(InterpretationParserTokenManager tm) {
    token_source = tm;
    token = new Token();
    jj_ntk = -1;
    jj_gen = 0;
    for (int i = 0; i < 0; i++) jj_la1[i] = -1;
    for (int i = 0; i < jj_2_rtns.length; i++) jj_2_rtns[i] = new JJCalls();
  }

  final private Token jj_consume_token(int kind) throws ParseException {
    Token oldToken;
    if ((oldToken = token).next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    if (token.kind == kind) {
      jj_gen++;
      if (++jj_gc > 100) {
        jj_gc = 0;
        for (int i = 0; i < jj_2_rtns.length; i++) {
          JJCalls c = jj_2_rtns[i];
          while (c != null) {
            if (c.gen < jj_gen) c.first = null;
            c = c.next;
          }
        }
      }
      trace_token(token, "");
      return token;
    }
    token = oldToken;
    jj_kind = kind;
    throw generateParseException();
  }

  static private final class LookaheadSuccess extends java.lang.Error { }
  final private LookaheadSuccess jj_ls = new LookaheadSuccess();
  final private boolean jj_scan_token(int kind) {
    if (jj_scanpos == jj_lastpos) {
      jj_la--;
      if (jj_scanpos.next == null) {
        jj_lastpos = jj_scanpos = jj_scanpos.next = token_source.getNextToken();
      } else {
        jj_lastpos = jj_scanpos = jj_scanpos.next;
      }
    } else {
      jj_scanpos = jj_scanpos.next;
    }
    if (jj_rescan) {
      int i = 0; Token tok = token;
      while (tok != null && tok != jj_scanpos) { i++; tok = tok.next; }
      if (tok != null) jj_add_error_token(kind, i);
    }
    if (jj_scanpos.kind != kind) return true;
    if (jj_la == 0 && jj_scanpos == jj_lastpos) throw jj_ls;
    return false;
  }

  final public Token getNextToken() {
    if (token.next != null) token = token.next;
    else token = token.next = token_source.getNextToken();
    jj_ntk = -1;
    jj_gen++;
      trace_token(token, " (in getNextToken)");
    return token;
  }

  final public Token getToken(int index) {
    Token t = lookingAhead ? jj_scanpos : token;
    for (int i = 0; i < index; i++) {
      if (t.next != null) t = t.next;
      else t = t.next = token_source.getNextToken();
    }
    return t;
  }

  final private int jj_ntk() {
    if ((jj_nt=token.next) == null)
      return (jj_ntk = (token.next=token_source.getNextToken()).kind);
    else
      return (jj_ntk = jj_nt.kind);
  }

  private java.util.Vector jj_expentries = new java.util.Vector();
  private int[] jj_expentry;
  private int jj_kind = -1;
  private int[] jj_lasttokens = new int[100];
  private int jj_endpos;

  private void jj_add_error_token(int kind, int pos) {
    if (pos >= 100) return;
    if (pos == jj_endpos + 1) {
      jj_lasttokens[jj_endpos++] = kind;
    } else if (jj_endpos != 0) {
      jj_expentry = new int[jj_endpos];
      for (int i = 0; i < jj_endpos; i++) {
        jj_expentry[i] = jj_lasttokens[i];
      }
      boolean exists = false;
      for (java.util.Enumeration e = jj_expentries.elements(); e.hasMoreElements();) {
        int[] oldentry = (int[])(e.nextElement());
        if (oldentry.length == jj_expentry.length) {
          exists = true;
          for (int i = 0; i < jj_expentry.length; i++) {
            if (oldentry[i] != jj_expentry[i]) {
              exists = false;
              break;
            }
          }
          if (exists) break;
        }
      }
      if (!exists) jj_expentries.addElement(jj_expentry);
      if (pos != 0) jj_lasttokens[(jj_endpos = pos) - 1] = kind;
    }
  }

  public ParseException generateParseException() {
    jj_expentries.removeAllElements();
    boolean[] la1tokens = new boolean[13];
    for (int i = 0; i < 13; i++) {
      la1tokens[i] = false;
    }
    if (jj_kind >= 0) {
      la1tokens[jj_kind] = true;
      jj_kind = -1;
    }
    for (int i = 0; i < 0; i++) {
      if (jj_la1[i] == jj_gen) {
        for (int j = 0; j < 32; j++) {
          if ((jj_la1_0[i] & (1<<j)) != 0) {
            la1tokens[j] = true;
          }
        }
      }
    }
    for (int i = 0; i < 13; i++) {
      if (la1tokens[i]) {
        jj_expentry = new int[1];
        jj_expentry[0] = i;
        jj_expentries.addElement(jj_expentry);
      }
    }
    jj_endpos = 0;
    jj_rescan_token();
    jj_add_error_token(0, 0);
    int[][] exptokseq = new int[jj_expentries.size()][];
    for (int i = 0; i < jj_expentries.size(); i++) {
      exptokseq[i] = (int[])jj_expentries.elementAt(i);
    }
    return new ParseException(token, exptokseq, tokenImage);
  }

  private int trace_indent = 0;
  private boolean trace_enabled = true;

  final public void enable_tracing() {
    trace_enabled = true;
  }

  final public void disable_tracing() {
    trace_enabled = false;
  }

  final private void trace_call(String s) {
    if (trace_enabled) {
      for (int i = 0; i < trace_indent; i++) { System.out.print(" "); }
      System.out.println("Call:   " + s);
    }
    trace_indent = trace_indent + 2;
  }

  final private void trace_return(String s) {
    trace_indent = trace_indent - 2;
    if (trace_enabled) {
      for (int i = 0; i < trace_indent; i++) { System.out.print(" "); }
      System.out.println("Return: " + s);
    }
  }

  final private void trace_token(Token t, String where) {
    if (trace_enabled) {
      for (int i = 0; i < trace_indent; i++) { System.out.print(" "); }
      System.out.print("Consumed token: <" + tokenImage[t.kind]);
      if (t.kind != 0 && !tokenImage[t.kind].equals("\"" + t.image + "\"")) {
        System.out.print(": \"" + t.image + "\"");
      }
      System.out.println(">" + where);
    }
  }

  final private void trace_scan(Token t1, int t2) {
    if (trace_enabled) {
      for (int i = 0; i < trace_indent; i++) { System.out.print(" "); }
      System.out.print("Visited token: <" + tokenImage[t1.kind]);
      if (t1.kind != 0 && !tokenImage[t1.kind].equals("\"" + t1.image + "\"")) {
        System.out.print(": \"" + t1.image + "\"");
      }
      System.out.println(">; Expected token: <" + tokenImage[t2] + ">");
    }
  }

  final private void jj_rescan_token() {
    jj_rescan = true;
    for (int i = 0; i < 14; i++) {
      JJCalls p = jj_2_rtns[i];
      do {
        if (p.gen > jj_gen) {
          jj_la = p.arg; jj_lastpos = jj_scanpos = p.first;
          switch (i) {
            case 0: jj_3_1(); break;
            case 1: jj_3_2(); break;
            case 2: jj_3_3(); break;
            case 3: jj_3_4(); break;
            case 4: jj_3_5(); break;
            case 5: jj_3_6(); break;
            case 6: jj_3_7(); break;
            case 7: jj_3_8(); break;
            case 8: jj_3_9(); break;
            case 9: jj_3_10(); break;
            case 10: jj_3_11(); break;
            case 11: jj_3_12(); break;
            case 12: jj_3_13(); break;
            case 13: jj_3_14(); break;
          }
        }
        p = p.next;
      } while (p != null);
    }
    jj_rescan = false;
  }

  final private void jj_save(int index, int xla) {
    JJCalls p = jj_2_rtns[index];
    while (p.gen > jj_gen) {
      if (p.next == null) { p = p.next = new JJCalls(); break; }
      p = p.next;
    }
    p.gen = jj_gen + xla - jj_la; p.first = token; p.arg = xla;
  }

  static final class JJCalls {
    int gen;
    Token first;
    int arg;
    JJCalls next;
  }

        }
